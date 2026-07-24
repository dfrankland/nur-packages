#!/usr/bin/env bash
#
# Run the packages' update scripts, the same way nixpkgs drives
# `passthru.updateScript`.
#
# Usage:
#   ./update.sh                 # update every package that has an updateScript
#   ./update.sh trunk tailscale # update only the named packages
#   ./update.sh firefox-addons  # regenerate the Firefox add-on set
#
# Each package exposes its updater as `passthru.updateScript` (a small script
# that knows where to look for new versions — see the comment next to it in the
# package's default.nix). This runner just realises and runs them from the
# repository root, where they expect to run.
#
# Updates are atomic per package: if a script fails partway (e.g. a moved
# download URL), that package is reset with `git checkout`, so a bumped version
# is never left paired with a stale hash. Run from a clean working tree.
#
# A package whose Nix code fails to evaluate is reported as an error (with the
# evaluation message) rather than silently skipped — only a genuinely absent
# `updateScript` is skipped.
#
# Firefox add-ons are a generated set rather than one derivation per source, so
# they are refreshed with `mozilla-addons-to-nix` (see
# pkgs/firefox-addons/README.md).
set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

system="$(nix eval --impure --raw --expr builtins.currentSystem)"

if [ -n "$(git status --porcelain -- pkgs 2>/dev/null)" ]; then
  echo "warning: pkgs/ has uncommitted changes. A failed update is reverted with" >&2
  echo "         'git checkout', which resets to the last commit — commit or stash" >&2
  echo "         first so a revert can't discard unrelated work." >&2
fi

# Run one package's update. Return codes:
#   0  ran successfully, or the package genuinely has no updateScript (skipped)
#   1  its update script ran and failed  -> caller reverts (may be half-applied)
#   2  its Nix code failed to evaluate   -> caller reports; nothing ran to revert
update_one() {
  local pkg="$1" script err
  if [[ "$pkg" == firefox-addons* ]]; then
    echo ">>> firefox-addons (regenerating with mozilla-addons-to-nix)"
    (
      cd pkgs/firefox-addons
      nix run sourcehut:~rycee/mozilla-addons-to-nix -- \
        addons.json generated-firefox-addons.nix
    ) || return 1
    return 0
  fi

  err="$(mktemp)"
  if script="$(nix build --no-link --print-out-paths \
    ".#packages.${system}.${pkg}.updateScript" 2>"$err")"; then
    rm -f "$err"
    echo ">>> $pkg"
    "$script" || return 1
    return 0
  fi

  # `nix build` failed. Only "does not provide attribute" means the package
  # simply has no updateScript; any other message is a real evaluation error.
  if grep -qF 'does not provide attribute' "$err"; then
    rm -f "$err"
    echo ">>> $pkg (no updateScript; skipping)"
    return 0
  fi
  echo ">>> $pkg (Nix evaluation failed):" >&2
  sed 's/^/    /' "$err" >&2
  rm -f "$err"
  return 2
}

# Which package directory does a target live in (for reverting on failure)?
dir_of() {
  case "$1" in
    firefox-addons*) echo pkgs/firefox-addons ;;
    *) echo "pkgs/$1" ;;
  esac
}

# The set of packages the flake actually exposes (attrNames doesn't force the
# derivations, so this works even if one package fails to evaluate).
mapfile -t all_pkgs < <(
  nix eval --json ".#packages.${system}" --apply builtins.attrNames | jq -r '.[]'
)
declare -A known=()
for p in "${all_pkgs[@]}"; do known["$p"]=1; done
known["firefox-addons"]=1 # alias for the whole generated add-on set

if [ "$#" -gt 0 ]; then
  targets=("$@")
else
  targets=("${all_pkgs[@]}")
fi

failed=()
did_firefox_addons=false
for pkg in "${targets[@]}"; do
  # A name that isn't a package at all (e.g. a typo) is an error, distinct from
  # a real package that simply has no updateScript.
  if [ -z "${known[$pkg]:-}" ]; then
    echo ">>> $pkg (no such package)" >&2
    failed+=("$pkg")
    continue
  fi

  # The whole firefox-addons set regenerates in one go; only do it once.
  if [[ "$pkg" == firefox-addons* ]]; then
    [ "$did_firefox_addons" = true ] && continue
    did_firefox_addons=true
  fi

  rc=0
  update_one "$pkg" || rc=$?
  case "$rc" in
    0) ;;
    1)
      echo "    !! $pkg update failed; reverting $(dir_of "$pkg")" >&2
      git checkout -- "$(dir_of "$pkg")" 2>/dev/null || true
      failed+=("$pkg")
      ;;
    *)
      # Evaluation error already reported; nothing ran, so nothing to revert.
      failed+=("$pkg")
      ;;
  esac
done

# Normalise formatting to satisfy `nix flake check` (the alejandra check).
echo ">>> formatting"
nix fmt ./ >/dev/null 2>&1 || true

if [ "${#failed[@]}" -gt 0 ]; then
  echo "FAILED, left unchanged: ${failed[*]}" >&2
fi
echo "Done. Review the changes with 'git diff' before committing."

[ "${#failed[@]}" -eq 0 ]

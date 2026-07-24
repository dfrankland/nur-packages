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

# Update a single package; returns non-zero if its script fails. The caller is
# responsible for reverting on failure.
update_one() {
  local pkg="$1" script
  if [[ "$pkg" == firefox-addons* ]]; then
    echo ">>> firefox-addons (regenerating with mozilla-addons-to-nix)"
    cd pkgs/firefox-addons
    nix run sourcehut:~rycee/mozilla-addons-to-nix -- \
      addons.json generated-firefox-addons.nix
    return
  fi
  script="$(nix build --no-link --print-out-paths \
    ".#packages.${system}.${pkg}.updateScript" 2>/dev/null || true)"
  if [ -z "$script" ]; then
    echo ">>> $pkg (no updateScript; skipping)"
    return
  fi
  echo ">>> $pkg"
  "$script"
}

# Which package directory does a target live in (for reverting on failure)?
dir_of() {
  case "$1" in
    firefox-addons*) echo pkgs/firefox-addons ;;
    *) echo "pkgs/$1" ;;
  esac
}

if [ "$#" -gt 0 ]; then
  targets=("$@")
else
  mapfile -t targets < <(
    nix eval --json ".#packages.${system}" --apply builtins.attrNames | jq -r '.[]'
  )
fi

failed=()
did_firefox_addons=false
for pkg in "${targets[@]}"; do
  # The whole firefox-addons set regenerates in one go; only do it once.
  if [[ "$pkg" == firefox-addons* ]]; then
    [ "$did_firefox_addons" = true ] && continue
    did_firefox_addons=true
  fi

  if ! (update_one "$pkg"); then
    echo "    !! $pkg failed; reverting" >&2
    git checkout -- "$(dir_of "$pkg")" 2>/dev/null || true
    failed+=("$pkg")
  fi
done

# Normalise formatting to satisfy `nix flake check` (the alejandra check).
echo ">>> formatting"
nix fmt ./ >/dev/null 2>&1 || true

if [ "${#failed[@]}" -gt 0 ]; then
  echo "FAILED (reverted, left unchanged): ${failed[*]}" >&2
fi
echo "Done. Review the changes with 'git diff' before committing."

[ "${#failed[@]}" -eq 0 ]

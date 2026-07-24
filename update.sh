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
# Each package exposes its updater as `passthru.updateScript` (a script that
# knows where to look for new versions — see the comment next to it in the
# package's default.nix). This runner just realises and executes them from the
# repository root, which is where those scripts expect to run.
#
# Firefox add-ons are generated as a set rather than one derivation per source,
# so they are refreshed with `mozilla-addons-to-nix` instead (see
# pkgs/firefox-addons/README.md).
set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

system="$(nix eval --impure --raw --expr builtins.currentSystem)"

update_firefox_addons() {
  echo ">>> firefox-addons (regenerating with mozilla-addons-to-nix)"
  (
    cd pkgs/firefox-addons
    nix run sourcehut:~rycee/mozilla-addons-to-nix -- \
      addons.json generated-firefox-addons.nix
  )
}

run_update_script() {
  local pkg="$1" script
  # `updateScript` is a writeScript derivation; realising it yields the script
  # file itself.
  if ! script="$(nix build --no-link --print-out-paths \
    ".#packages.${system}.${pkg}.updateScript" 2>/dev/null)"; then
    return 1
  fi
  [ -n "$script" ] || return 1
  echo ">>> $pkg"
  "$script"
}

# Build the list of packages to update.
if [ "$#" -gt 0 ]; then
  targets=("$@")
else
  mapfile -t targets < <(
    nix eval --json ".#packages.${system}" --apply builtins.attrNames | jq -r '.[]'
  )
fi

did_firefox_addons=false
for pkg in "${targets[@]}"; do
  case "$pkg" in
    firefox-addons | firefox-addons-*)
      if [ "$did_firefox_addons" = false ]; then
        update_firefox_addons
        did_firefox_addons=true
      fi
      ;;
    *)
      run_update_script "$pkg" || echo "    (no updateScript; skipping)"
      ;;
  esac
done

# Normalise formatting to satisfy `nix flake check` (the alejandra check).
echo ">>> formatting"
nix fmt ./ >/dev/null 2>&1 || true

echo "Done. Review the changes with 'git diff' before committing."

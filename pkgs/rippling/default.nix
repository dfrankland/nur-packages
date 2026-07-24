{
  lib,
  stdenv,
  fetchurl,
  undmg,
  writeScript,
}:
# https://formulae.brew.sh/api/cask/rippling.json
let
  app = "Rippling.app";
  version = "3.6.52";
in
  stdenv.mkDerivation {
    pname = "rippling";
    inherit version;

    src = fetchurl {
      url = "https://public-assets.ripplingcdn.com/global/hardware-public/device_release/electron-installer/${version}/macos/Rippling.dmg";
      sha256 = "sha256-hioUam2VOCIkx+bRqGMXyMYdeNRAHFvA7oWZkY9EzQ0=";
    };

    sourceRoot = app;

    buildInputs = [undmg];
    dontFixup = true; # Don't break code signing. Check with `codesign -dv ./result/Applications/Rippling.app`
    installPhase = ''
      mkdir -p "$out/Applications/${app}"
      cp -R . "$out/Applications/${app}"
    '';

    # There is no upstream version feed, so track the Homebrew cask; nix-update
    # then refetches the dmg to update the hash.
    passthru.updateScript = writeScript "update-rippling" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p nix-update curl jq
      set -euo pipefail
      version="$(curl -fsSL https://formulae.brew.sh/api/cask/rippling.json | jq -r .version)"
      nix-update --flake rippling --version "$version"
    '';

    meta = {
      description = "Rippling device management";
      homepage = "https://app.rippling.com/downloads/hardware-management/";
      license = lib.licenses.unfree;
      platforms = ["aarch64-darwin"];
    };
  }

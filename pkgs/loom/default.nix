{
  lib,
  stdenv,
  fetchurl,
  unpackdmg,
  writeScript,
}:
# https://formulae.brew.sh/api/cask/loom.json
let
  app = "Loom.app";
  version = "0.332.0";
  cpu = "-arm64";
  sha256 = "sha256-2tXUiP8qjleW2KIsg30IV+Xu38a+xsPIb1qWpIW9aJg=";
in
  stdenv.mkDerivation {
    pname = "loom";
    inherit version;

    src = fetchurl {
      url = "https://packages.loom.com/desktop-packages/Loom-${version}${cpu}.dmg";
      inherit sha256;
    };

    sourceRoot = app;

    dontFixup = true; # Don't break code signing. Check with `codesign -dv ./result/Applications/Loom.app`
    buildInputs = [unpackdmg];
    installPhase = ''
      mkdir -p "$out/Applications/${app}"
      cp -R . "$out/Applications/${app}"
    '';

    # There is no upstream version feed, so track the Homebrew cask; nix-update
    # then refetches the dmg to update the hash.
    passthru.updateScript = writeScript "update-loom" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p nix-update curl jq
      set -euo pipefail
      version="$(curl -fsSL https://formulae.brew.sh/api/cask/loom.json | jq -r .version)"
      nix-update --flake loom --version "$version"
    '';

    meta = {
      description = "Screen and video recording software";
      homepage = "https://www.loom.com/";
      license = lib.licenses.unfree;
      platforms = ["aarch64-darwin"];
    };
  }

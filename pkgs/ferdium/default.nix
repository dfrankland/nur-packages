{
  lib,
  stdenv,
  fetchzip,
  ferdium,
  writeScript,
}:
if (!stdenv.isDarwin)
then ferdium
else let
  app = "Ferdium.app";
  version = "7.1.2";
in
  stdenv.mkDerivation {
    pname = "ferdium";
    inherit version;

    src = fetchzip {
      url = "https://github.com/ferdium/ferdium-app/releases/download/v${version}/Ferdium-mac-bundle-${version}-arm64.zip";
      sha256 = "sha256-tiRTZ9KMj7pS+QSWF3pJVvIcsw+8AQ4CpNPWpGqbWGE=";
      stripRoot = false;
    };

    dontFixup = true; # Don't break code signing. Check with `codesign -dv ./result/Applications/Ferdium.app`
    installPhase = ''
      mkdir -p "$out/Applications"
      cp -R "${app}" "$out/Applications/"
    '';

    # Releases are published on GitHub (ferdium/ferdium-app); nix-update reads the
    # latest tag from there (stripping the leading `v`).
    passthru.updateScript = writeScript "update-ferdium" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p nix-update
      set -euo pipefail
      nix-update --flake ferdium
    '';

    meta = {
      description = "Messaging app that combines chat and messaging services into one application";
      homepage = "https://ferdium.org/";
      changelog = "https://github.com/ferdium/ferdium-app/releases/tag/v${version}";
      license = lib.licenses.asl20;
      platforms = ["aarch64-darwin"];
    };
  }

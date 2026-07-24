{
  lib,
  stdenv,
  fetchzip,
  writeScript,
}: let
  app = "MacThrottle.app";
  asset = "MacThrottle-${version}.zip";
  version = "1.8.2";
in
  stdenv.mkDerivation {
    pname = "macthrottle";
    inherit version;

    src = fetchzip {
      url = "https://github.com/angristan/MacThrottle/releases/download/v${version}/${asset}";
      sha256 = "sha256-eiHZYo6bY51x6cn/ZkCFJnSaZUFNrt+DvVKgNTpWW1M=";
      stripRoot = false;
    };

    dontFixup = true; # Don't break code signing. Check with `codesign -dv ./result/Applications/MacThrottle.app`
    installPhase = ''
      mkdir -p "$out/Applications"
      cp -R "${app}" "$out/Applications/"
    '';

    # Releases are published on GitHub (angristan/MacThrottle); nix-update reads
    # the latest tag from there.
    passthru.updateScript = writeScript "update-macthrottle" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p nix-update
      set -euo pipefail
      nix-update --flake macthrottle
    '';

    meta = {
      description = "A lightweight macOS menu bar app that monitors thermal pressure";
      homepage = "https://github.com/angristan/MacThrottle";
      changelog = "https://github.com/angristan/MacThrottle/releases/tag/v${version}";
      license = lib.licenses.mit;
      platforms = ["aarch64-darwin"];
    };
  }

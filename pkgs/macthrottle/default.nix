{
  lib,
  stdenv,
  fetchzip,
}: let
  app = "MacThrottle.app";
  asset = "MacThrottle-${version}.zip";
  version = "1.7.3";
in
  stdenv.mkDerivation {
    pname = "macthrottle";
    inherit version;

    src = fetchzip {
      url = "https://github.com/angristan/MacThrottle/releases/download/v${version}/${asset}";
      sha256 = "sha256-OmT2XEidXFI0etl79K0Am11ngBDS7PSNrmHcyLXlp3M=";
      stripRoot = false;
    };

    dontFixup = true; # Don't break code signing. Check with `codesign -dv ./result/Applications/MacThrottle.app`
    installPhase = ''
      mkdir -p "$out/Applications"
      cp -R "${app}" "$out/Applications/"
    '';

    meta = {
      description = "A lightweight macOS menu bar app that monitors thermal pressure";
      homepage = "https://github.com/angristan/MacThrottle";
      changelog = "https://github.com/angristan/MacThrottle/releases/tag/v${version}";
      license = lib.licenses.mit;
      platforms = ["aarch64-darwin"];
    };
  }

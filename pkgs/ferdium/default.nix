{
  lib,
  stdenv,
  fetchzip,
  ferdium,
}:
if (!stdenv.isDarwin)
then ferdium
else let
  app = "Ferdium.app";
  version = "7.1.1";
in
  stdenv.mkDerivation {
    pname = "ferdium";
    inherit version;

    src = fetchzip {
      url = "https://github.com/ferdium/ferdium-app/releases/download/v${version}/Ferdium-mac-bundle-${version}-arm64.zip";
      sha256 = "sha256-xPtc5YuIyYbilkJCETYWfEtftFylThAzE/1wWmgncXI=";
      stripRoot = false;
    };

    dontFixup = true; # Don't break code signing. Check with `codesign -dv ./result/Applications/Ferdium.app`
    installPhase = ''
      mkdir -p "$out/Applications"
      cp -R "${app}" "$out/Applications/"
    '';

    meta = {
      description = "Messaging app that combines chat and messaging services into one application";
      homepage = "https://ferdium.org/";
      changelog = "https://github.com/ferdium/ferdium-app/releases/tag/v${version}";
      license = lib.licenses.asl20;
      platforms = ["aarch64-darwin"];
    };
  }

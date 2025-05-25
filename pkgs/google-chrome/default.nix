{ lib, stdenv, fetchurl, unpackdmg, google-chrome }:

if (!stdenv.isDarwin) then
  google-chrome
else
# https://formulae.brew.sh/api/cask/google-chrome.json
  stdenv.mkDerivation {
    pname = "google-chrome";
    version = "136.0.7103.49";

    src = fetchurl {
      url = "https://dl.google.com/chrome/mac/universal/stable/GGRO/googlechrome.dmg";
      sha256 = "sha256-DkWZYfEq7nkUkOZ/D3+JNK8/OHCn4Uek8J9Z8yeym8E=";
    };

    buildInputs = [ unpackdmg ];
    installPhase = ''
      mkdir -p "$out/Applications"
      cp -R 'Google Chrome.app' "$out/Applications/"
    '';

    meta = {
      description = "A freeware web browser developed by Google";
      homepage = "https://www.google.com/chrome/browser/";
      license = lib.licenses.unfree;
      platforms = lib.platforms.darwin;
    };
  }

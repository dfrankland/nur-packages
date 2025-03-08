{ lib, stdenv, fetchurl, unpackdmg, google-chrome }:

if (!stdenv.isDarwin) then
  google-chrome
else
# https://formulae.brew.sh/api/cask/google-chrome.json
  stdenv.mkDerivation {
    pname = "google-chrome";
    version = "132.0.6834.84";

    src = fetchurl {
      url = "https://dl.google.com/chrome/mac/universal/stable/GGRO/googlechrome.dmg";
      sha256 = "sha256-ihz2hc/e4l4lJCBfIareW9dREW0YE7gZCmkt4WyQqhc=";
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

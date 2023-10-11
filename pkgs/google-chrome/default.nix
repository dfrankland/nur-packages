{ lib, stdenv, fetchurl, unpackdmg, google-chrome }:

if (!stdenv.isDarwin) then
  google-chrome
else
  stdenv.mkDerivation {
    pname = "google-chrome";
    version = "118.0.5993.70";

    src = fetchurl {
      url = "https://dl.google.com/chrome/mac/universal/stable/GGRO/googlechrome.dmg";
      sha256 = "sha256-6zIFAT27XJ9rfKCI89iaPXhIiFew8SGhX5WibOk6Yj8=";
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

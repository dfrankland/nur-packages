{ lib, stdenv, fetchurl, undmg, google-chrome }:

if (!stdenv.isDarwin) then
  google-chrome
else
  let
    app = "Google Chrome.app";
  in
  stdenv.mkDerivation {
    pname = "google-chrome";
    version = "114.0.5735.198";

    src = fetchurl {
      url = "https://dl.google.com/chrome/mac/universal/stable/GGRO/googlechrome.dmg";
      sha256 = "sha256-2Z6nddlPGUSqWT0Du1iHLupnlQMlJYMKf6j7Y0ftf7A=";
    };

    sourceRoot = app;

    buildInputs = [ undmg ];
    installPhase = ''
      mkdir -p "$out/Applications/${app}"
      cp -R . "$out/Applications/${app}"
    '';

    meta = {
      description = "A freeware web browser developed by Google";
      homepage = "https://www.google.com/chrome/browser/";
      license = lib.licenses.unfree;
      platforms = lib.platforms.darwin;
    };
  }

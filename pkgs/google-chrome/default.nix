{ lib, stdenv, fetchurl, undmg, google-chrome }:

if (!stdenv.isDarwin) then
  google-chrome
else
  let
    app = "Google Chrome.app";
  in
  stdenv.mkDerivation {
    pname = "google-chrome";
    version = "115.0.5790.170";

    src = fetchurl {
      url = "https://dl.google.com/chrome/mac/universal/stable/GGRO/googlechrome.dmg";
      sha256 = "sha256-C59+BqvWtsAH0Xgpz4/9e+3Ljhhfu6igOA1pGejrUCk=";
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

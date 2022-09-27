{ lib, stdenv, fetchurl, undmg, google-chrome }:

if (!stdenv.isDarwin) then
  google-chrome
else
  let
    app = "Google Chrome.app";
  in
  stdenv.mkDerivation {
    pname = "google-chrome";
    version = "106.0.5249.61";

    src = fetchurl {
      url = "https://dl.google.com/chrome/mac/universal/stable/GGRO/googlechrome.dmg";
      sha256 = "sha256-eWmjYcV3edMfhFN0UEI0PyNUyeFPnZELNi/j+3zR23g=";
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

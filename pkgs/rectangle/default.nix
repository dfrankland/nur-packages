{ lib, stdenv, fetchurl, undmg }:

let
  app = "Rectangle.app";
  version = "0.73";
in
stdenv.mkDerivation {
  pname = "rectangle";
  inherit version;

  src = fetchurl {
    url = "https://github.com/rxhanson/Rectangle/releases/download/v${version}/Rectangle${version}.dmg";
    sha256 = "sha256-D+heCrJVo2xsKY9XtEuhrG/59yFIJTGhKJIfN9Vhc+M=";
  };

  sourceRoot = app;

  buildInputs = [ undmg ];
  installPhase = ''
    mkdir -p "$out/Applications/${app}"
    cp -R . "$out/Applications/${app}"
  '';

  meta = {
    description = "Rectangle is a window management app based on Spectacle, written in Swift.";
    homepage = "https://rectangleapp.com/";
    license = lib.licenses.mit;
    platforms = lib.platforms.darwin;
  };
}

{ lib, stdenv, fetchurl, undmg }:

let
  app = "Rectangle.app";
  version = "0.64";
in
stdenv.mkDerivation {
  pname = "rectangle";
  inherit version;

  src = fetchurl {
    url = "https://github.com/rxhanson/Rectangle/releases/download/v${version}/Rectangle${version}.dmg";
    sha256 = "cf8c638b4ef68465059f1c0298c1371715be759bb334aa0cbcc435ee8459a1c7";
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

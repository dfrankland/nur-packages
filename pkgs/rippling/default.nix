{ lib, stdenv, fetchurl, undmg }:

let
  app = "Rippling.app";
  version = "3.5.62";
in
stdenv.mkDerivation {
  pname = "rippling";
  inherit version;

  src = fetchurl {
    url = "https://hardware-cdn.rippling.com/installers/Rippling.dmg";
    sha256 = "sha256-geIxR5v7TvusqO/OJtdsQ38jOVeF7oXXL394pYaWxSk=";
  };

  sourceRoot = app;

  buildInputs = [ undmg ];
  installPhase = ''
    mkdir -p "$out/Applications/${app}"
    cp -R . "$out/Applications/${app}"
  '';

  meta = {
    description = "Rippling device management";
    homepage = "https://app.rippling.com/downloads/hardware-management/";
    license = lib.licenses.unfree;
    platforms = lib.platforms.darwin;
  };
}

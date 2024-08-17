{ lib, stdenv, fetchurl, undmg }:

let
  app = "Rippling.app";
  version = "3.6.32";
in
stdenv.mkDerivation {
  pname = "rippling";
  inherit version;

  src = fetchurl {
    url = "https://hardware-cdn.rippling.com/installers/Rippling.dmg";
    sha256 = "sha256-EREi/j6k/8ZMysUZCXA3VQQa8Rcz9nNLLeDPqkoPNAs=";
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

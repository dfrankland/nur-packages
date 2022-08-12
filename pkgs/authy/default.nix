{ lib, stdenv, fetchurl, undmg, authy }:

if (!stdenv.isDarwin) then
  authy
else
  let
    app = "Authy Desktop.app";
    version = "2.2.1";
  in
  stdenv.mkDerivation rec {
    pname = "authy";
    inherit version;

    src = fetchurl {
      url = "https://s3.amazonaws.com/authy-electron-repository-production/authy/stable/${version}/darwin/x64/Authy%20Desktop-${version}.dmg";
      sha256 = "sha256-iGY/foPOxaOcQzbfn7OVswRHQxyJAtB2khHx4xAG0ts=";
    };

    sourceRoot = app;

    buildInputs = [ undmg ];
    installPhase = ''
      mkdir -p "$out/Applications/${app}"
      cp -R . "$out/Applications/${app}"
    '';

    meta = with lib; {
      homepage = "https://www.authy.com";
      description = "Twilio Authy two factor authentication desktop application";
      license = licenses.unfree;
      platforms = lib.platforms.darwin;
    };
  }

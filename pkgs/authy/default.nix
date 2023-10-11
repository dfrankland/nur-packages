{ lib, stdenv, fetchurl, unpackdmg, authy }:

if (!stdenv.isDarwin) then
  authy
else
  let
    app = "Authy Desktop.app";
    version = "2.4.1";
  in
  stdenv.mkDerivation rec {
    pname = "authy";
    inherit version;

    src = fetchurl {
      url = "https://pkg.authy.com/authy/stable/${version}/darwin/x64/Authy%20Desktop-${version}.dmg";
      sha256 = "sha256-9SgI36CcI9v0szAOGHtWdfmtbjBNdJImvMEKOIfZuk0=";
    };

    buildInputs = [ unpackdmg ];
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

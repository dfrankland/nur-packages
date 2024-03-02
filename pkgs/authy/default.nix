{ lib, stdenv, fetchurl, unpackdmg, authy }:

if (!stdenv.isDarwin) then
  authy
else
# https://formulae.brew.sh/api/cask/authy.json
  let
    app = "Authy Desktop.app";
    version = "2.5.0";
  in
  stdenv.mkDerivation rec {
    pname = "authy";
    inherit version;

    src = fetchurl {
      url = "https://pkg.authy.com/authy/stable/${version}/darwin/x64/Authy%20Desktop-${version}.dmg";
      sha256 = "sha256-cRb6Njju3Gb5R6y9dTgOHg8Q4NfnE2njuznOmfgplFU=";
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

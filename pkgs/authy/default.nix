{ lib, stdenv, fetchurl, undmg, authy }:

if (!stdenv.isDarwin) then
  authy
else
  let
    app = "Authy Desktop.app";
    version = "2.2.2";
  in
  stdenv.mkDerivation rec {
    pname = "authy";
    inherit version;

    src = fetchurl {
      url = "https://pkg.authy.com/authy/stable/${version}/darwin/x64/Authy%20Desktop-${version}.dmg";
      sha256 = "bf76d0d7b64311f41644bdd5e5d5584eaf8ca11e5962459227beac40c754872e";
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

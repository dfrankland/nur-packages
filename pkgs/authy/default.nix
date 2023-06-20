{ lib, stdenv, fetchurl, undmg, xz, authy }:

if (!stdenv.isDarwin) then
  authy
else
  let
    app = "Authy Desktop.app";
    version = "2.3.0";
  in
  stdenv.mkDerivation rec {
    pname = "authy";
    inherit version;

    src = fetchurl {
      url = "https://pkg.authy.com/authy/stable/${version}/darwin/x64/Authy%20Desktop-${version}.dmg";
      sha256 = "5166fd399d3dfe1ff2afcd8652f708518caf2689529d3f43bb41bb692ad4ec81";
    };

    sourceRoot = app;

    buildInputs = [ xz undmg ];
    unpackPhase =
      let
        dmg = "Authy Desktop-${version}.dmg";
      in
      ''
        runHook preUnpack

        file $src
        cp $src ./Authy-Desktop-2.3.0.dmg.xz
        xz -d Authy-Desktop-2.3.0.dmg.xz
        undmg Authy-Desktop-2.3.0.dmg

        runHook postUnpack
      '';
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

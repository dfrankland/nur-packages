{ lib, stdenv, fetchurl, undmg, wavebox }:

if (!stdenv.isDarwin) then
  wavebox
else
  let
    app = "Wavebox.app";
    version = "10.98.9.2";
  in
  stdenv.mkDerivation {
    pname = "wavebox";
    inherit version;

    src = fetchurl {
      name = "wavebox-${version}.dmg";
      url = "https://download.wavebox.app/stable/macuniversal/Install%20Wavebox%20${version}.dmg";
      sha256 = "sha256-eKO8iaTTftMDnXMAHS3EwW7M2bdO/DjSn5ZZ+OQBnro=";
    };

    sourceRoot = app;

    buildInputs = [ undmg ];
    installPhase = ''
      mkdir -p "$out/Applications/${app}"
      cp -R . "$out/Applications/${app}"
    '';

    meta = {
      description = "Wavebox messaging application";
      homepage = "https://wavebox.io";
      license = lib.licenses.mpl20;
      platforms = lib.platforms.darwin;
    };
  }

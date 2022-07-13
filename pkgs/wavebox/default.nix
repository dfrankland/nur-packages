{ lib, stdenv, fetchurl, undmg, wavebox }:

if (!stdenv.isDarwin) then
  wavebox
else
  let
    app = "Wavebox.app";
    version = "10.103.28.2";
  in
  stdenv.mkDerivation {
    pname = "wavebox";
    inherit version;

    src = fetchurl {
      name = "wavebox-${version}.dmg";
      url = "https://download.wavebox.app/stable/macuniversal/Install%20Wavebox%20${version}.dmg";
      sha256 = "sha256-rXJj+GJZ98T4WP4RugJ5BaiMYDX9dv2K84f3nLyG5Gk=";
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

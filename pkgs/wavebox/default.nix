{ lib, stdenv, fetchurl, undmg, wavebox }:

if (!stdenv.isDarwin) then
  wavebox
else
  let
    app = "Wavebox.app";
    version = "10.117.21.2";
  in
  stdenv.mkDerivation {
    pname = "wavebox";
    inherit version;

    src = fetchurl {
      name = "wavebox-${version}.dmg";
      url = "https://download.wavebox.app/stable/macuniversal/Install%20Wavebox%20${version}.dmg";
      sha256 = "sha256-SItO9oaOXp1/HR56mI7RGvJMnSdWvIjNnDKWIk2m5gA=";
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

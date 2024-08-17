{ lib, stdenv, fetchurl, undmg, wavebox }:

if (!stdenv.isDarwin) then
  wavebox
else
# https://formulae.brew.sh/api/cask/wavebox.json
  let
    app = "Wavebox.app";
    version = "10.127.16.2";
  in
  stdenv.mkDerivation {
    pname = "wavebox";
    inherit version;

    src = fetchurl {
      name = "wavebox-${version}.dmg";
      url = "https://download.wavebox.app/stable/macuniversal/Install%20Wavebox%20${version}.dmg";
      sha256 = "sha256-8QDRrh4ZtUrwfwWTQeYzGf5/zC9BEVgh1hvftyPtO0k=";
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

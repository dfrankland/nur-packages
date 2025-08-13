{ lib, stdenv, fetchurl, undmg, wavebox }:

if (!stdenv.isDarwin) then
  wavebox
else
# https://formulae.brew.sh/api/cask/wavebox.json
  let
    app = "Wavebox.app";
    version = "10.139.12.2";
  in
  stdenv.mkDerivation {
    pname = "wavebox";
    inherit version;

    src = fetchurl {
      name = "wavebox-${version}.dmg";
      url = "https://download.wavebox.app/stable/macuniversal/Install%20Wavebox%20${version}.dmg";
      sha256 = "sha256-IP5B1bZUK9F0ghruqGcqmwbC4js7NY5pldzVKPIjqMg=";
    };

    sourceRoot = app;

    buildInputs = [ undmg ];
    # Don't break code signing. Check with `codesign -dv ./result/Applications/Wavebox.app`.
    # Also, stripping is slow on x86_64.
    dontFixup = true;
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

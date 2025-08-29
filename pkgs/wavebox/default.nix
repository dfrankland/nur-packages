{ lib, stdenv, fetchzip, wavebox }:

if (!stdenv.isDarwin) then
  wavebox
else
# https://formulae.brew.sh/api/cask/wavebox.json
  let
    app = "Wavebox.app";
    version = "10.139.20.2";
    platform = if (stdenv.hostPlatform.isAarch64) then "macarm64" else "mac";
  in
  stdenv.mkDerivation {
    pname = "wavebox";
    inherit version;

    src = fetchzip {
      name = "wavebox-${version}.dmg";
      url = "https://download.wavebox.app/stable/${platform}/Wavebox_${version}.zip";
      sha256 = "sha256-ad11n31UuZg4ImHEUOGlkIuESPtGihnSwx+K/KDHYMY=";
      stripRoot = false;
    };

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

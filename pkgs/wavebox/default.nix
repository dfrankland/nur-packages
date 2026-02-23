{ lib, stdenv, fetchzip, wavebox }:

if (!stdenv.isDarwin) then
  wavebox
else
# https://formulae.brew.sh/api/cask/wavebox.json
  let
    app = "Wavebox.app";
    version = "10.145.17.2";
    platform = if (stdenv.hostPlatform.isAarch64) then "macarm64" else "mac";
  in
  stdenv.mkDerivation {
    pname = "wavebox";
    inherit version;

    src = fetchzip {
      name = "wavebox-${version}.dmg";
      url = "https://download.wavebox.app/stable/${platform}/Wavebox_${version}.zip";
      sha256 = "sha256-e7H2dsf/lGIDug14N+1FvSncAKB9u323YJ7TTbTa8x4=";
      stripRoot = false;
    };

    # Don't break code signing. Check with `codesign -dv ./result/Applications/Wavebox.app`.
    # Also, stripping is slow on x86_64.
    dontFixup = true;
    installPhase = ''
      mkdir -p "$out/Applications/"
      cp -R . "$out/Applications/"
    '';

    meta = {
      description = "Wavebox messaging application";
      homepage = "https://wavebox.io";
      license = lib.licenses.mpl20;
      platforms = lib.platforms.darwin;
    };
  }

{ lib, stdenv, fetchurl, unpackdmg, ungoogled-chromium }:

if (!stdenv.isDarwin) then
  ungoogled-chromium
else
  let
    version = "139.0.7258.138-1.1";
  in
  stdenv.mkDerivation {
    pname = "ungoogled-chromium";
    inherit version;

    src = fetchurl {
      url = "https://github.com/ungoogled-software/ungoogled-chromium-macos/releases/download/${version}/ungoogled-chromium_${version}_arm64-macos.dmg";
      sha256 = "sha256-f7gTkcyhdORJSdZ0t0OH+rdFlfJKdi+9XERAZmvO6us=";
    };

    buildInputs = [ unpackdmg ];
    installPhase = ''
      mkdir -p "$out/Applications"
      cp -R 'Chromium.app' "$out/Applications/"
    '';

    meta = {
      description = "Google Chromium, sans integration with Google";
      homepage = "https://github.com/ungoogled-software/ungoogled-chromium";
      license = lib.licenses.bsd3;
      platforms = lib.platforms.darwin;
    };
  }

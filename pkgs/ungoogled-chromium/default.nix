{ lib, stdenv, fetchurl, unpackdmg, ungoogled-chromium }:

if (!stdenv.isDarwin) then
  ungoogled-chromium
else
# https://formulae.brew.sh/api/cask/eloston-chromium.json
  let
    version = "136.0.7103.113-1.1";
  in
  stdenv.mkDerivation {
    pname = "ungoogled-chromium";
    inherit version;

    src = fetchurl {
      url = "https://github.com/ungoogled-software/ungoogled-chromium-macos/releases/download/${version}/ungoogled-chromium_${version}_arm64-macos.dmg";
      sha256 = "sha256-llaXl2jEegL0DyUBHDW15d8jNXr+kF+TJkrBONIlXCU=";
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

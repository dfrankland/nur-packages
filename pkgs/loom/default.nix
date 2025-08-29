{ lib, stdenv, fetchurl, unpackdmg }:

# https://formulae.brew.sh/api/cask/loom.json
let
  app = "Loom.app";
  version = "0.314.0";
  cpu = if (stdenv.hostPlatform.isAarch64) then "-arm64" else "";
  sha256 =
    if (stdenv.hostPlatform.isAarch64)
    then "sha256-k5MaSK19drRhlv2gAyEbSW6s/9nj6/n7X2zKKoZb6GY="
    else lib.fakeSha256;
in
stdenv.mkDerivation {
  pname = "loom";
  inherit version;

  src = fetchurl {
    url = "https://packages.loom.com/desktop-packages/Loom-${version}${cpu}.dmg";
    inherit sha256;
  };

  sourceRoot = app;

  dontFixup = true; # Don't break code signing. Check with `codesign -dv ./result/Applications/Loom.app`
  buildInputs = [ unpackdmg ];
  installPhase = ''
    mkdir -p "$out/Applications/${app}"
    cp -R . "$out/Applications/${app}"
  '';

  meta = {
    description = "Screen and video recording software";
    homepage = "https://www.loom.com/";
    license = lib.licenses.unfree;
    platforms = lib.platforms.darwin;
  };
}

{ lib, stdenv, fetchurl, unpackdmg }:

# https://formulae.brew.sh/api/cask/loom.json
let
  app = "Loom.app";
  version = "0.309.2";
  cpu = if (stdenv.hostPlatform.isAarch64) then "-arm64" else "";
  sha256 =
    if (stdenv.hostPlatform.isAarch64)
    then "sha256-yMXK436BdleKsurCUVdpanncXokJKG8Fs5xAb57JjMU="
    else "sha256-GuFAyBP8tG0bkn46SKPq5sqSeDc1V75WzsoQJYZaXkM=";
in
stdenv.mkDerivation {
  pname = "loom";
  inherit version;

  src = fetchurl {
    url = "https://packages.loom.com/desktop-packages/Loom-${version}${cpu}.dmg";
    inherit sha256;
  };

  sourceRoot = app;

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

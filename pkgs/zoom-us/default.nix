{ lib, stdenv, fetchurl, xar, cpio, pbzx, zoom-us }:

if (!stdenv.isDarwin) then
  zoom-us
else
  let
    app = "zoom.us.app";
    version = "5.16.2.23409";
    arch = if (stdenv.hostPlatform.isAarch64) then "arm64/" else "";
    sha256 =
      if (stdenv.hostPlatform.isAarch64)
      then "sha256-8K2d2i99fuaatoFR5h2ho3H3GCULIOi/IYMLvnL5VxA="
      else "sha256-Og7t9NyuwNQIIIaIeWnkTxqQ2MBEHGs8GliUctrueL8=";
  in
  stdenv.mkDerivation {
    pname = "zoom-us";
    inherit version;

    src = fetchurl {
      url = "https://cdn.zoom.us/prod/${version}/${arch}Zoom.pkg";
      inherit sha256;
    };

    nativeBuildInputs = [ xar cpio pbzx ];

    unpackPhase = ''
      xar -x -f $src
    '';

    installPhase = ''
      pbzx -n ./zoomus.pkg/Payload | cpio -idm
      mkdir -p "$out/Applications"
      cp -R ./${app} "$out/Applications/"
    '';

    meta = {
      homepage = "https://zoom.us/";
      description = "zoom.us video conferencing application";
      license = lib.licenses.unfree;
      platforms = lib.platforms.darwin;
    };
  }

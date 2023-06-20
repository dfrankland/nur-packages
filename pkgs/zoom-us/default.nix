{ lib, stdenv, fetchurl, xar, cpio, pbzx, zoom-us }:

if (!stdenv.isDarwin) then
  zoom-us
else
  let
    app = "zoom.us.app";
    version = "5.14.10.19202";
    arch = if (stdenv.hostPlatform.isAarch64) then "arm64/" else "";
    sha256 =
      if (stdenv.hostPlatform.isAarch64)
      then "c5e344ee6010215967042a428ece58b44a720f0aa32d307ea52ede6c3d7c61d4"
      else "598dc99817cd78100b254efd2b132a5280a39aef4c350f3cc5b0bfd007db7c84";
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

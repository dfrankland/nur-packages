{ lib, stdenv, fetchurl, xar, cpio, pbzx, gzip, zoom-us }:

if (!stdenv.isDarwin) then
  zoom-us
else
  let
    app = "zoom.us.app";
    version = "5.10.0.5714";
    arch = if (stdenv.hostPlatform.isAarch64) then "arm64/" else "";
    sha256 = if (stdenv.hostPlatform.isAarch64) then "sha256-MOdKdEAg+/bNmgXXWxSSjIc64oKcpv3cpFoegydGZDQ=" else "sha256-p/oKPaDHMvnxWnzTJQnC6jPP0edvFjelMfLOQGj9ZIA=";
  in
  stdenv.mkDerivation {
    pname = "zoom-us";
    inherit version;

    src = fetchurl {
      url = "https://cdn.zoom.us/prod/5.10.0.5714/${arch}Zoom.pkg";
      inherit sha256;
    };

    nativeBuildInputs = [ xar cpio pbzx gzip ];

    unpackPhase = ''
      xar -x -f $src
    '';

    installPhase = ''
      gunzip < ./zoomus.pkg/Payload | cpio -idm
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

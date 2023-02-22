{ lib, stdenv, fetchurl, xar, cpio, pbzx, zoom-us }:

if (!stdenv.isDarwin) then
  zoom-us
else
  let
    app = "zoom.us.app";
    version = "5.13.7.15481";
    arch = if (stdenv.hostPlatform.isAarch64) then "arm64/" else "";
    sha256 = if (stdenv.hostPlatform.isAarch64) then "6fa82035e94fed3d8276327284d3ebd1c51637613c76c58586345b48813c3afd" else "e8e70702b940c1ab4574a055720f3448617293763f04a62936cbf7b240fb1690";
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

{ lib, stdenv, fetchurl, xar, cpio, pbzx, zoom-us }:

if (!stdenv.isDarwin) then
  zoom-us
else
# https://formulae.brew.sh/api/cask/zoom.json
  let
    app = "zoom.us.app";
    version = "5.17.10.30974";
    arch = if (stdenv.hostPlatform.isAarch64) then "arm64/" else "";
    sha256 =
      if (stdenv.hostPlatform.isAarch64)
      then "sha256-Wu8b6FICJ9h+m8rR6f8lRw0lJqS/in8CA/91ZS6n0hw="
      else "sha256-wzCB5/5Yvn+t4GVXhVfKaH+oAom3lVwNeR8tCHsNh8M=";
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

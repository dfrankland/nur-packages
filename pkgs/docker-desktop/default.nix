{ lib, stdenv, fetchurl, unpackdmg, dpkg, makeWrapper }:

let
  # get the lastest version from https://docs.docker.com/desktop/release-notes/
  version = "4.53.0";
  rev = "211793";
  platform = if (stdenv.isDarwin) then "mac" else "linux";
  cpu = if (stdenv.hostPlatform.isAarch64) then "arm64" else "amd64";
  sha256 =
    if (platform == "mac" && cpu == "arm64")
    then "45b220c6bdcce748d94d83271b607a684a918c1b24eb2fc2b8807fe798912834"
    else if (platform == "mac" && cpu == "amd64")
    then "73fcfabd1c7311ee628f1a4c6f63769b0ec72f73258cf3cf807d1c76874aabe3"
    else "3a4e2cebabac0971728e07c01d2919f5931d6f7af2f8b7af5ec6cd45778e4c68";
  file = if (stdenv.isDarwin) then "Docker.dmg" else "docker-desktop-amd64.deb";
  app = "Docker.app";
in
stdenv.mkDerivation {
  pname = "docker-desktop";
  inherit version;

  src = fetchurl {
    url = "https://desktop.docker.com/${platform}/main/${cpu}/${rev}/${file}";
    inherit sha256;
  };

  nativeBuildInputs = if (stdenv.isDarwin) then [ unpackdmg makeWrapper ] else [ dpkg ];
  dontFixup = true; # Don't break code signing. Check with `codesign -dv ./result/Applications/Docker.app`
  installPhase =
    if (stdenv.isDarwin) then ''
      mkdir -p "$out/Applications"
      cp -R '${app}' "$out/Applications/"
      makeWrapper \
        "$out/Applications/${app}/Contents/Resources/bin/docker-credential-desktop" \
        "$out/bin/docker-credential-desktop"
      makeWrapper \
        "$out/Applications/${app}/Contents/Resources/bin/docker-credential-osxkeychain" \
        "$out/bin/docker-credential-osxkeychain"
      # NOTE: There are more binaries that can be wrapped (docker, kubectl, extension-admin, hub-tool, etc.)
    '' else ''
      # TODO!
    '';

  meta = with lib; {
    homepage = "https://www.docker.com/products/docker-desktop/";
    description = "Docker Desktop is an easy-to-install application for your Mac or Windows environment that enables you to build and share containerized applications and microservices.";
    license = licenses.unfree;
    platforms = lib.platforms.unix;
  };
}

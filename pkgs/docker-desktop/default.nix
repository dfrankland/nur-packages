{ lib, stdenv, fetchurl, unpackdmg, dpkg, makeWrapper }:

let
  # get the lastest version from https://docs.docker.com/desktop/release-notes/
  version = "4.45.0";
  rev = "203075";
  platform = if (stdenv.isDarwin) then "mac" else "linux";
  cpu = if (stdenv.hostPlatform.isAarch64) then "arm64" else "amd64";
  sha256 =
    if (platform == "mac" && cpu == "arm64")
    then "ef7d6c7160e46bf6cd01f686ac1e9519d4d932e0cc9767b1cd9cb9f7e61f7433"
    else if (platform == "mac" && cpu == "amd64")
    then "b48db3cdaadb60d794e8732e99abcd74300454d5c4e8616866934d8cc66dec16"
    else "1e050f8204357e82fe50be6c054399b13930d504e7a3b3cb88d31a1e6fea65a0";
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

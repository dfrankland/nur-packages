{ lib, stdenv, fetchurl, unpackdmg, dpkg }:

let
  # get the lastest version from https://docs.docker.com/desktop/release-notes/
  version = "4.44.1";
  rev = "201842";
  platform = if (stdenv.isDarwin) then "mac" else "linux";
  cpu = if (stdenv.hostPlatform.isAarch64) then "arm64" else "amd64";
  sha256 =
    if (platform == "mac" && cpu == "arm64")
    then "bb962186dada3d95a388e745a02fb3ccb7c1b6f5e4201dec33fd4df677110e81"
    else if (platform == "mac" && cpu == "amd64")
    then "4cd8d0368cba4fdb3ba8c5bf8edde49d0994fcce03e3b8517422dbf48a5ea4f9"
    else "5c7e8f61622d5b4aadbdae85821a99d936fc1792ed864e2cf9da991f76aee1c5";
  file = if (stdenv.isDarwin) then "Docker.dmg" else "docker-desktop-amd64.deb";
in
stdenv.mkDerivation {
  pname = "docker-desktop";
  inherit version;

  src = fetchurl {
    url = "https://desktop.docker.com/${platform}/main/${cpu}/${rev}/${file}";
    inherit sha256;
  };

  nativeBuildInputs = if (stdenv.isDarwin) then [ unpackdmg ] else [ dpkg ];
  dontFixup = true; # Don't break code signing. Check with `codesign -dv ./result/Applications/Docker.app`
  installPhase =
    if (stdenv.isDarwin) then ''
      mkdir -p "$out/Applications"
      cp -R 'Docker.app' "$out/Applications/"
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

{ lib, stdenv, fetchurl, unpackdmg, dpkg, authy }:

let
  # get the lastest version from https://docs.docker.com/desktop/release-notes/
  version = "4.28.0";
  rev = "139021";
  platform = if (stdenv.isDarwin) then "mac" else "linux";
  cpu = if (stdenv.hostPlatform.isAarch64) then "arm64" else "amd64";
  sha256 =
    if (platform == "mac" && cpu == "arm64")
    then "bbea580cbda59233c620a258e4a27369e04d5068735a087b8e13622d5e69fcd5"
    else if (platform == "mac" && cpu == "amd64")
    then "2bd6e03121d608dad89261ca14f6e495fdcca97e36231b43da2d7a762047df9d"
    else "4f2799366028803cd37284f48ec44c7ab6a1953112378621263d8fa62574d658";
  file = if (stdenv.isDarwin) then "Docker.dmg" else "docker-desktop-${version}-${cpu}.deb";
in
stdenv.mkDerivation rec {
  pname = "docker-desktop";
  inherit version;

  src = fetchurl {
    url = "https://desktop.docker.com/${platform}/main/${cpu}/${rev}/${file}";
    inherit sha256;
  };

  nativeBuildInputs = if (stdenv.isDarwin) then [ unpackdmg ] else [ dpkg ];
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

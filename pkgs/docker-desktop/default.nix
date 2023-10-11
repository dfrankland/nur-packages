{ lib, stdenv, fetchurl, unpackdmg, dpkg, authy }:

let
  # get the lastest version from https://docs.docker.com/desktop/release-notes/
  version = "4.24.0";
  rev = "122432";
  platform = if (stdenv.isDarwin) then "mac" else "linux";
  cpu = if (stdenv.hostPlatform.isAarch64) then "arm64" else "amd64";
  sha256 =
    if (platform == "mac" && cpu == "arm64")
    then "048e28f9834179008d4728ad59171584b793a76f5d2d52c13b577d1bbb2f699b"
    else if (platform == "mac" && cpu == "amd64")
    then "67ba11934540270ad37ede8c4d6b3b73ef393690ee2aebca04b6591d22ffe4c5"
    else "56a53cdbd15167aeef6687aa952009e394bca19f7eb37fb69dc52f20adfed079";
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

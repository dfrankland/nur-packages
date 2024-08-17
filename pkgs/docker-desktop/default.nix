{ lib, stdenv, fetchurl, unpackdmg, dpkg }:

let
  # get the lastest version from https://docs.docker.com/desktop/release-notes/
  version = "4.33.0";
  rev = "160616";
  platform = if (stdenv.isDarwin) then "mac" else "linux";
  cpu = if (stdenv.hostPlatform.isAarch64) then "arm64" else "amd64";
  sha256 =
    if (platform == "mac" && cpu == "arm64")
    then "33070a04c96d8778fd7aaa6f06b4b656b6d9cad243f6db7111b4aa560f6dedc4"
    else if (platform == "mac" && cpu == "amd64")
    then "33070a04c96d8778fd7aaa6f06b4b656b6d9cad243f6db7111b4aa560f6dedc4"
    else "087301fb44e421c1113389994ab5b4e50d25c9b3a0413460fa8abe1527a253fa";
  file = if (stdenv.isDarwin) then "Docker.dmg" else "docker-desktop-${version}-${cpu}.deb";
in
stdenv.mkDerivation {
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

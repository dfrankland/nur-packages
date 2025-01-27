{ lib, stdenv, fetchurl, unpackdmg, dpkg }:

let
  # get the lastest version from https://docs.docker.com/desktop/release-notes/
  version = "4.37.2";
  rev = "179585";
  platform = if (stdenv.isDarwin) then "mac" else "linux";
  cpu = if (stdenv.hostPlatform.isAarch64) then "arm64" else "amd64";
  sha256 =
    if (platform == "mac" && cpu == "arm64")
    then "624dec2ae9fc2269e07533921f5905c53514d698858dde25ab10f28f80e333c7"
    else if (platform == "mac" && cpu == "amd64")
    then "5f58f3acff80bfadaef62e5873810f609ac77df6ebbde99d44360fb6aa93a45d"
    # There's no `4.37.2` version for linux ¯\_(ツ)_/¯
    else "";
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

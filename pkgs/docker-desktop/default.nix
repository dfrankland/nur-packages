{ lib, stdenv, fetchurl, unpackdmg, dpkg }:

let
  # get the lastest version from https://docs.docker.com/desktop/release-notes/
  version = "4.37.2";
  rev = "184744";
  platform = if (stdenv.isDarwin) then "mac" else "linux";
  cpu = if (stdenv.hostPlatform.isAarch64) then "arm64" else "amd64";
  sha256 =
    if (platform == "mac" && cpu == "arm64")
    then "553a0b9d155af21ce9dd524a3f59d421f3ac8109c913a2c6bd663f25770803d3"
    else if (platform == "mac" && cpu == "amd64")
    then "1b4e7efccbf0569bfcff23fa7df5e5f11ee4ae31dabc0aa974c8b1b45042832f"
    else "aa28f130921466b5cf00641d79d25fd3f406de9656604df797f41d70a0bfd287";
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

{ lib, stdenv, fetchurl, undmg, dpkg, authy }:

let
  # TODO: Mac version cannot be updated until `undmg` supports XZ file
  # compression.
  app = "Docker.app";
  version = "4.11.1";
  rev = "84025";
  platform = if (stdenv.isDarwin) then "mac" else "linux";
  cpu = if (stdenv.hostPlatform.isAarch64) then "arm64" else "amd64";
  sha256 =
    if (platform == "mac" && cpu == "arm64")
    then "a7d84117bef83764cb9bf275cd01b8ba0c43f08dbfe4d4a7d4f05549cdd81f54"
    else if (platform == "mac" && cpu == "amd64")
    then "b2f4ad8fea37dfb7d9147f169a9ceab71d7d0d12ff912057c60b58c0e91aed35"
    else "8877443ded0dee19b1bacaa608bd81d4bb216b59ff5fc12c89489e9ac5b00e0f";
  file = if (stdenv.isDarwin) then "Docker.dmg" else "docker-desktop-${version}-${cpu}.deb";
in
stdenv.mkDerivation rec {
  pname = "docker-desktop";
  inherit version;

  src = fetchurl {
    url = "https://desktop.docker.com/${platform}/main/${cpu}/${rev}/${file}";
    inherit sha256;
  };

  sourceRoot = lib.optional stdenv.isDarwin app;

  nativeBuildInputs = if (stdenv.isDarwin) then [ undmg ] else [ dpkg ];
  installPhase =
    if (stdenv.isDarwin) then ''
      mkdir -p "$out/Applications/${app}"
      cp -R . "$out/Applications/${app}"
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

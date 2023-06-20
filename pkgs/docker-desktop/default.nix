{ lib, stdenv, fetchurl, undmg, dpkg, authy }:

let
  # TODO: Mac version cannot be updated until `undmg` supports XZ file
  # compression.
  app = "Docker.app";
  version = "4.20.1";
  rev = "110738";
  platform = if (stdenv.isDarwin) then "mac" else "linux";
  cpu = if (stdenv.hostPlatform.isAarch64) then "arm64" else "amd64";
  sha256 =
    if (platform == "mac" && cpu == "arm64")
    then "24869f0ba82b6fab37d09e6f13df091d59f5f878ba325c99d3b36bf67858ccf9"
    else if (platform == "mac" && cpu == "amd64")
    then "f0af9a5bf1309d1628d67a693ba67c0373a4bbeab165499d4cdb903ee60a9213"
    else "b4dc1b7db87e5b84e08e794281707180323c9e49c37f2752b94a4bc5a89dbde1";
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

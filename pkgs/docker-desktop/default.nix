{ lib, stdenv, fetchurl, unpackdmg, dpkg }:

let
  # get the lastest version from https://docs.docker.com/desktop/release-notes/
  version = "4.41.2";
  rev = "191736";
  platform = if (stdenv.isDarwin) then "mac" else "linux";
  cpu = if (stdenv.hostPlatform.isAarch64) then "arm64" else "amd64";
  sha256 =
    if (platform == "mac" && cpu == "arm64")
    then "19c69b358a8ee1b94e308648a2853e398f4bff29f0f74f00ef2d1b462ced1d1c"
    else if (platform == "mac" && cpu == "amd64")
    then "51a14a53808659f02b48f571dcf0e3cdb03a7e69cc51cc9ecb519bf6b10403df"
    else "c36f6aba835873d2088f512b0c4da566792136947980d433fa5a5ac76a981add";
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

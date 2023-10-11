{ autoPatchelfHook, fetchurl, makeWrapper, lib, stdenv }:

with lib;

let
  # get the lastest version from https://trunk.io/releases/latest
  version = "1.16.2";
  platform = if (stdenv.isDarwin) then "darwin" else "linux";
  cpu = if (stdenv.hostPlatform.isAarch64) then "arm64" else "x86_64";
  sha256 =
    if (platform == "darwin" && cpu == "arm64")
    then "7818813eea3d1ad4da5253bb2cb3c589d140b7d725aac33ae24d2cbc48dc79f8"
    else if (platform == "darwin" && cpu == "x86_64")
    then "9ee5079a35fb767e2b63ec7ccb13ef9bafb52b9c2c37f19facf536a6f2063b95"
    else if (cpu == "x86_64")
    then "3a513dd0da86e037649f811a4dda2523cb84e93a132f13feff80161f12f624ca"
    else "22b107f47d7f6285cd4da1f1851f085aaa810e2fff035ccf603183dc413b479f";
in
stdenv.mkDerivation {
  pname = "trunk";
  inherit version;
  src = fetchurl {
    url = "https://trunk.io/releases/${version}/trunk-${version}-${platform}-${cpu}.tar.gz";
    inherit sha256;
  };

  # Work around the "unpacker appears to have produced no directories"
  # case that happens when the archive doesn't have a subdirectory.
  setSourceRoot = "sourceRoot=`pwd`";

  nativeBuildInputs = lib.optionals stdenv.isLinux [ autoPatchelfHook makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    cp ./trunk $out/bin/
  '';

  meta = with lib; {
    description = "Trunk all-in-one tool for scalably checking, testing, merging, and monitoring code";
    homepage = "https://trunk.io";
    license = licenses.unfree;
    platforms = lib.platforms.unix;
  };
}

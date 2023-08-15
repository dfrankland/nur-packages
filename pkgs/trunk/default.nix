{ autoPatchelfHook, fetchurl, makeWrapper, lib, stdenv }:

with lib;

let
  # get the lastest version from https://trunk.io/releases/latest
  version = "1.13.0";
  platform = if (stdenv.isDarwin) then "darwin" else "linux";
  cpu = if (stdenv.hostPlatform.isAarch64) then "arm64" else "x86_64";
  sha256 =
    if (platform == "darwin" && cpu == "arm64")
    then "65d0a311050db922867899bb28864297c712c9df95dfc01a44f2229e7a75a35d"
    else if (platform == "darwin" && cpu == "x86_64")
    then "22b828b95c75e92f6e6dc5b3a8ad91fd79c60cbbe237bff0ef3b0bbf4569b057"
    else "6f56f424daeb96f9fd8a3986d9c556720bd91b702a2e46d1d496bfff431f94f0";
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

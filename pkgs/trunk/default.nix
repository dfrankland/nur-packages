{ autoPatchelfHook, fetchurl, makeWrapper, lib, stdenv }:

with lib;

let
  # curl -sL 'https://trunk.io/releases/latest'
  version = "1.25.0";
  platform = if (stdenv.isDarwin) then "darwin" else "linux";
  cpu = if (stdenv.hostPlatform.isAarch64) then "arm64" else "x86_64";
  sha256 =
    if (platform == "darwin" && cpu == "arm64")
    then "2cff4f1cc63916db290359a058b88167beeac07a496682d9307a1804b498f225"
    else if (platform == "darwin" && cpu == "x86_64")
    then "d0153b87a7eba4cd7d09a048b97bd60ac3ac15352def2bc3599d548875823ed3"
    else if (cpu == "x86_64")
    then "3845ff76a70cebb10e61a267ff719ffdccfa3ef6d877d51870a2c62b79603ab9"
    else "cc210d2185cf95bedbec06384be6ef342bdb7dcf3ff72dd08fe0e69859516887";
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

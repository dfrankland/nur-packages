{ autoPatchelfHook, fetchurl, makeWrapper, lib, stdenv }:

with lib;

let
  # curl -sL 'https://trunk.io/releases/latest'
  version = "1.22.3";
  platform = if (stdenv.isDarwin) then "darwin" else "linux";
  cpu = if (stdenv.hostPlatform.isAarch64) then "arm64" else "x86_64";
  sha256 =
    if (platform == "darwin" && cpu == "arm64")
    then "fc8488e59d845706c6712e969aa05056615b97b46cd55567225d89dde0ae599a"
    else if (platform == "darwin" && cpu == "x86_64")
    then "509f2a5fbebce66db40d553278a8eca2fc60ee13b6ba79f9ba7ea51b737f4e3a"
    else if (cpu == "x86_64")
    then "3ce4330af33edb15fe682e3bdfc77025d5ed39f7b0c7ef201ff5a734ee8720b3"
    else "d3954a80dcb98b7fb82704c5ae66c90616ee0c7a4eff1ef7b772f33f976fb50f";
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

{ autoPatchelfHook, fetchurl, makeWrapper, lib, stdenv }:

with lib;

let
  # curl -sL 'https://trunk.io/releases/latest'
  version = "1.22.1";
  platform = if (stdenv.isDarwin) then "darwin" else "linux";
  cpu = if (stdenv.hostPlatform.isAarch64) then "arm64" else "x86_64";
  sha256 =
    if (platform == "darwin" && cpu == "arm64")
    then "be937c5e7b94461b58b4eee95cfab79d3eed816183ccacefc0f1b9d1c14fe20c"
    else if (platform == "darwin" && cpu == "x86_64")
    then "3f496405112b1e0e55dfced29ba2fc8d57cf8142e12ae7a4ce39a331a9791b0f"
    else if (cpu == "x86_64")
    then "f4704ed97a727648f7a0d442f88cebeecc2c687c4866fb8e771d39ca33372c2f"
    else "479be4f0efc64cc581ab1f85a0c4a60b6065b31a637028569189de5c3ca7f15b";
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

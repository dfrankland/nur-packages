{ autoPatchelfHook, fetchurl, makeWrapper, lib, stdenv }:

with lib;

let
  # curl -sL 'https://trunk.io/releases/latest'
  version = "1.22.10";
  platform = if (stdenv.isDarwin) then "darwin" else "linux";
  cpu = if (stdenv.hostPlatform.isAarch64) then "arm64" else "x86_64";
  sha256 =
    if (platform == "darwin" && cpu == "arm64")
    then "e2fe80efc0fd6d07eb2d03562eea62945352e4f9027edc2ab1c10603084cac88"
    else if (platform == "darwin" && cpu == "x86_64")
    then "77e7e7275825aa8528a50ae53b58252a6a45748cb36bbd0837bb5719ed79830d"
    else if (cpu == "x86_64")
    then "ad62b96f3b97b8dfff1b245e7d40f41c31d12ce7a2d158d72dd44723f0ad041a"
    else "fa67cca348ae3f35f0577d3ddaf0f6f42a7bed0701e91d2650db876c3c08c5da";
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

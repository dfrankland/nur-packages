{ autoPatchelfHook, fetchurl, makeWrapper, lib, stdenv }:

with lib;

let
  # curl -sL 'https://trunk.io/releases/latest'
  version = "1.22.15";
  platform = if (stdenv.isDarwin) then "darwin" else "linux";
  cpu = if (stdenv.hostPlatform.isAarch64) then "arm64" else "x86_64";
  sha256 =
    if (platform == "darwin" && cpu == "arm64")
    then "f3abcc1346445342fa0e1e12f90d13e3b6720bdfa71e51e35832a7f771a0698c"
    else if (platform == "darwin" && cpu == "x86_64")
    then "38fde47e68331fd48f03e2e0396f35b4ee76e3d9e1aff995e6fad46793b91c75"
    else if (cpu == "x86_64")
    then "d30873fb5416ad4242ea3f1a5a3fac1883a38c9ddd7b8c4ae36aa1324371817b"
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

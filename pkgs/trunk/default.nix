{ autoPatchelfHook, fetchurl, makeWrapper, lib, stdenv }:

with lib;

let
  # get the lastest version from https://trunk.io/releases/latest
  version = "0.11.0-beta";
  platform = if (stdenv.isDarwin) then "darwin" else "linux";
  cpu = if (stdenv.hostPlatform.isAarch64) then "arm64" else "x86_64";
  sha256 = if (platform == "darwin" && cpu == "arm64")
    then "c6b2ab71aff04ae510ed52faf92816a4d7f1559b2647e4de16cf7e88c5ac5afb"
    else if (platform == "darwin" && cpu == "x86_64")
    then "2a2177605b743b94aa36e5ea7fa100105ac5b3bc8132d8661e441396baa59c60"
    else "791979441af605c631338ede3f442cc3c7d27e262b95777faf0c965de6e19ea4";
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

  nativeBuildInputs = [ autoPatchelfHook makeWrapper ];

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

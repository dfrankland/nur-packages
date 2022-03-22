{ autoPatchelfHook, fetchurl, makeWrapper, lib, stdenv }:

with lib;

let
  # get the lastest version from https://trunk.io/releases/latest
  version = "0.8.1-beta";
  platform = if (stdenv.isDarwin) then "darwin" else "linux";
  sha256 = if (stdenv.isDarwin) then "sha256-sjB4dCUYFNbLwXtOWq0O8yRsPNxPk5w7pt6FWJpsXg4=" else "6f4ce9ea0d0f249536fda82f94304e1642cf0637709acba6cdab26ca36253140";
in
stdenv.mkDerivation {
  pname = "trunk";
  inherit version;
  src = fetchurl {
    url = "https://trunk.io/releases/${version}/trunk-${version}.${platform}.tar.gz";
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

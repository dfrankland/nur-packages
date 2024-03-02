{ autoPatchelfHook, fetchurl, makeWrapper, lib, stdenv }:

with lib;

let
  # curl -sL 'https://trunk.io/releases/latest'
  version = "1.20.1";
  platform = if (stdenv.isDarwin) then "darwin" else "linux";
  cpu = if (stdenv.hostPlatform.isAarch64) then "arm64" else "x86_64";
  sha256 =
    if (platform == "darwin" && cpu == "arm64")
    then "ccf460a7f4357ac0a2750bc3e1a602ae41ee342bc7fa7b22c1cdf3046aecacff"
    else if (platform == "darwin" && cpu == "x86_64")
    then "91743ec926223583ad42b3951e79a57e3d85d2d398a78b97bcf09b83e3774a7f"
    else if (cpu == "x86_64")
    then "9a32c464da3d7d5dc3e4254ea28fd4130539d8e92665d22649bd01b670fe2cab"
    else "eae75b5212644238dbcf747d9974bef58068d5b4240dcd8c1234d452f417779e";
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

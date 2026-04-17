{
  lib,
  stdenv,
  fetchurl,
  zmx,
}:
if !stdenv.isDarwin
then zmx.packages.${stdenv.hostPlatform.system}.default
else let
  version = "0.5.0";
  platform =
    if stdenv.hostPlatform.isAarch64
    then "aarch64"
    else "x86_64";
  sha256 =
    if stdenv.hostPlatform.isAarch64
    then "sha256-O5N58P8M8Qf3+HBI0sRfb76r7ViNZ2rYasIYvtko0Qc="
    else "sha256-d27kjv1Q0L2Xtm+ktDA6JmKVwKDhYwRbc6xmJo1XgbY=";
in
  stdenv.mkDerivation {
    pname = "zmx";
    inherit version;

    src = fetchurl {
      url = "https://zmx.sh/a/zmx-${version}-macos-${platform}.tar.gz";
      inherit sha256;
    };

    # The release tarball contains the binary at the archive root.
    setSourceRoot = "sourceRoot=`pwd`";

    installPhase = ''
      runHook preInstall

      install -Dm755 zmx "$out/bin/zmx"

      runHook postInstall
    '';

    meta = {
      description = "Session persistence for terminal processes";
      homepage = "https://github.com/neurosnap/zmx";
      license = lib.licenses.mit;
      mainProgram = "zmx";
      platforms = lib.platforms.darwin;
      sourceProvenance = [lib.sourceTypes.binaryNativeCode];
    };
  }

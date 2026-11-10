{
  autoPatchelfHook,
  fetchurl,
  makeWrapper,
  lib,
  stdenv,
  writeScript,
}:
with lib; let
  # curl -sL 'https://trunk.io/releases/latest'
  version = "1.29.0";
  platform =
    if (stdenv.isDarwin)
    then "darwin"
    else "linux";
  cpu =
    if (stdenv.isDarwin || stdenv.hostPlatform.isAarch64)
    then "arm64"
    else "x86_64";
  sha256 =
    if (platform == "darwin" && cpu == "arm64")
    then "a3e55ccc8a55998b9944de8eb41b7fc0133988cbe36eec1fa5a14d4e8efc60fd"
    else if (cpu == "x86_64")
    then "39b7bfdc8eda677e595b83172c5fc7bd2e7588f4c6926aa56ff3e26578e9b3e8"
    else "f6a6678dbe392f2f11a27bd41a7fd6cf52b4b366c93b3ae0df16ca521ebffcf6";
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

    nativeBuildInputs = lib.optionals stdenv.isLinux [autoPatchelfHook makeWrapper];

    installPhase = ''
      mkdir -p $out/bin
      cp ./trunk $out/bin/
    '';

    # `https://trunk.io/releases/latest` reports the current version together
    # with the sha256 (hex) of every platform tarball, so we can patch the
    # version and all three pinned hashes without refetching anything.
    passthru.updateScript = writeScript "update-trunk" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p curl gnused
      set -euo pipefail
      file=pkgs/trunk/default.nix
      latest="$(curl -fsSL https://trunk.io/releases/latest)"
      version="$(printf '%s\n' "$latest" | sed -n 's/^version: //p')"
      darwin_arm64="$(printf '%s\n' "$latest" | sed -n 's/^[[:space:]]*darwin_arm64: //p')"
      linux_x86_64="$(printf '%s\n' "$latest" | sed -n 's/^[[:space:]]*linux_x86_64: //p')"
      linux_arm64="$(printf '%s\n' "$latest" | sed -n 's/^[[:space:]]*linux_arm64: //p')"
      # Current hashes, in the order they appear in the file:
      # [darwin_arm64, linux_x86_64, linux_arm64].
      mapfile -t old < <(grep -oE '[0-9a-f]{64}' "$file")
      sed -i \
        -e "s/version = \"[^\"]*\"/version = \"$version\"/" \
        -e "s/''${old[0]}/$darwin_arm64/" \
        -e "s/''${old[1]}/$linux_x86_64/" \
        -e "s/''${old[2]}/$linux_arm64/" \
        "$file"
    '';

    meta = with lib; {
      description = "Trunk all-in-one tool for scalably checking, testing, merging, and monitoring code";
      homepage = "https://trunk.io";
      license = licenses.unfree;
      platforms = ["x86_64-linux" "aarch64-linux" "aarch64-darwin"];
    };
  }

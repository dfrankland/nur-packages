{
  lib,
  stdenv,
  fetchzip,
  chromium,
  writeScript,
}:
if (!stdenv.isDarwin)
then chromium
else
  # Go to either
  # https://commondatastorage.googleapis.com/chromium-browser-snapshots/index.html?prefix=Mac/
  # OR
  # https://commondatastorage.googleapis.com/chromium-browser-snapshots/index.html?prefix=Mac_Arm/
  # and filter for `LAST_CHANGE` to find the version number of the latest release
  let
    version = "1508458";
    arch = "Mac_Arm";
    sha256 = "sha256-02f3tY+Q7S772BDwj/0oWGtZaNCWNb9SM19EGLzQd6Q=";
  in
    stdenv.mkDerivation {
      pname = "chromium";
      inherit version;

      src = fetchzip {
        url = "https://commondatastorage.googleapis.com/chromium-browser-snapshots/${arch}/${version}/chrome-mac.zip";
        inherit sha256;
      };

      # Don't break code signing. Check with `codesign -dv ./result/Applications/Chromium.app`.
      # Also, stripping is slow on x86_64.
      dontFixup = true;
      installPhase = ''
        mkdir -p "$out/Applications"
        cp -R 'Chromium.app' "$out/Applications/"
      '';

      # The "version" is the latest snapshot build number, published as the
      # `LAST_CHANGE` marker for the Mac_Arm snapshot channel; nix-update then
      # refetches chrome-mac.zip to update the hash.
      passthru.updateScript = writeScript "update-chromium" ''
        #!/usr/bin/env nix-shell
        #!nix-shell -i bash -p nix-update curl
        set -euo pipefail
        version="$(curl -fsSL https://commondatastorage.googleapis.com/chromium-browser-snapshots/Mac_Arm/LAST_CHANGE)"
        nix-update --flake chromium --version "$version"
      '';

      meta = {
        description = "An open source web browser from Google (binary release)";
        downloadPage = "https://commondatastorage.googleapis.com/chromium-browser-snapshots/index.html";
        homepage = "https://www.chromium.org/Home/";
        license = lib.licenses.bsd3;
        platforms = ["aarch64-darwin"];
      };
    }

{
  lib,
  stdenv,
  fetchurl,
  unpackdmg,
  ungoogled-chromium,
  writeScript,
}:
if (!stdenv.isDarwin)
then ungoogled-chromium
else let
  version = "152.0.7977.82-1.1";
in
  stdenv.mkDerivation {
    pname = "ungoogled-chromium";
    inherit version;

    src = fetchurl {
      url = "https://github.com/ungoogled-software/ungoogled-chromium-macos/releases/download/${version}/ungoogled-chromium_${version}_arm64-macos.dmg";
      sha256 = "sha256-umc4dlM+ebPAntrz69Da3MKenQESubhD2MAyz7e/tFc=";
    };

    buildInputs = [unpackdmg];
    installPhase = ''
      mkdir -p "$out/Applications"
      cp -R 'Chromium.app' "$out/Applications/"
    '';

    # Releases are published on GitHub (ungoogled-software/ungoogled-chromium-macos);
    # nix-update reads the latest tag from there.
    passthru.updateScript = writeScript "update-ungoogled-chromium" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p nix-update
      set -euo pipefail
      nix-update --flake ungoogled-chromium
    '';

    meta = {
      description = "Google Chromium, sans integration with Google";
      homepage = "https://github.com/ungoogled-software/ungoogled-chromium";
      license = lib.licenses.bsd3;
      platforms = ["aarch64-darwin"];
    };
  }

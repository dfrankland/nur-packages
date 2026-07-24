{
  lib,
  stdenv,
  fetchzip,
  undmg,
  writeScript,
}: let
  app = "QMK Toolbox.app";
  version = "0.3.3";
in
  stdenv.mkDerivation rec {
    pname = "qmk_toolbox";
    inherit version;

    src = fetchzip {
      url = "https://github.com/qmk/qmk_toolbox/releases/download/${version}/QMK.Toolbox.app.zip";
      sha256 = "sha256-0wxNd531dmSlgN/v0+VvjvnV7RmHN5lL4bALVy97Gqw=";
    };

    buildInputs = [undmg];
    installPhase = ''
      mkdir -p "$out/Applications/${app}"
      cp -R . "$out/Applications/${app}"
    '';

    # Releases are published on GitHub (qmk/qmk_toolbox); nix-update reads the
    # latest tag from there.
    passthru.updateScript = writeScript "update-qmk_toolbox" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p nix-update
      set -euo pipefail
      nix-update --flake qmk_toolbox
    '';

    meta = {
      description = "A Toolbox companion for QMK Firmware";
      homepage = "https://github.com/qmk/qmk_toolbox";
      license = lib.licenses.mit;
      platforms = ["aarch64-darwin"];
    };
  }

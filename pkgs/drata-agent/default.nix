{
  lib,
  stdenv,
  fetchurl,
  unpackdmg,
  writeScript,
}: let
  app = "Drata Agent.app";
  version = "3.8.0";
in
  stdenv.mkDerivation {
    pname = "drata-agent";
    inherit version;

    src = fetchurl {
      url = "https://github.com/drata/agent-releases/releases/download/${version}/Drata-Agent-mac.dmg";
      sha256 = "sha256-SGodojTQBZraDClHwEHpUSD4lTTgcLHXPORQPSrfYi0=";
    };

    buildInputs = [unpackdmg];
    dontFixup = true; # Don't break code signing. Check with `codesign -dv ./result/Applications/Drata\ Agent.app`
    installPhase = ''
      mkdir -p "$out/Applications/${app}"
      cp -R . "$out/Applications/${app}"
    '';

    # Releases are published on GitHub (drata/agent-releases); nix-update reads
    # the latest tag from there.
    passthru.updateScript = writeScript "update-drata-agent" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p nix-update
      set -euo pipefail
      nix-update --flake drata-agent
    '';

    meta = {
      description = "Drata compliance agent";
      homepage = "https://app.drata.com/employee/install-agent";
      license = lib.licenses.unfree;
      platforms = ["aarch64-darwin"];
    };
  }

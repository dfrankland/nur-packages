{
  lib,
  fetchFromGitHub,
  caddy,
  makeWrapper,
  buildNpmPackage,
  writeScript,
}:
# https://github.com/gurucomputing/headscale-ui/releases
let
  version = "2026.03.17";
  pname = "headscale-ui";
in
  buildNpmPackage rec {
    inherit pname version;

    src = fetchFromGitHub {
      owner = "gurucomputing";
      repo = pname;
      rev = version;
      sha256 = "sha256-JR+VLwXqMKACWB+4AIgWLIpZh0xtU9uCsiskra71BHQ=";
    };

    npmDepsHash = "sha256-vtMRi81GCaZDnfyZG5Eth/kPKQeIAsxhqKcc74ij7lg=";

    nativeBuildInputs = [makeWrapper];

    npmInstallFlags = ["--logs-max=0"];

    makeCacheWritable = true;

    buildPhase = ''
      substituteInPlace src/routes/settings.html/+page.svelte --replace "insert-version" "${version}"
      npm run build
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin
      cp -R build $out
      cp docker/production/Caddyfile $out
      substituteInPlace $out/Caddyfile --replace "root /web" "root $out/build"
      makeWrapper \
        ${caddy}/bin/caddy \
        $out/bin/${pname} \
        --set-default HTTP_PORT 3000 \
        --set-default HTTPS_PORT 3443 \
        --add-flags "run --adapter caddyfile --config $out/Caddyfile"

      runHook postInstall
    '';

    # Releases are published on GitHub (gurucomputing/headscale-ui); nix-update
    # reads the latest tag from there and also refreshes `npmDepsHash`.
    passthru.updateScript = writeScript "update-headscale-ui" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p nix-update
      set -euo pipefail
      nix-update --flake headscale-ui
    '';

    meta = {
      description = "A web frontend for the headscale Tailscale-compatible coordination server";
      homepage = "https://github.com/gurucomputing/headscale-ui";
      license = lib.licenses.bsd3;
    };
  }

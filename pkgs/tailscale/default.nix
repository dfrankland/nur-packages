{
  lib,
  stdenv,
  fetchzip,
  tailscale,
  makeWrapper,
  writeScript,
}:
if (!stdenv.isDarwin)
then tailscale
else
  # https://pkgs.tailscale.com/stable/#macos
  let
    app = "Tailscale.app";
    version = "1.86.4";
  in
    stdenv.mkDerivation rec {
      pname = "tailscale";
      inherit version;

      src = fetchzip {
        url = "https://pkgs.tailscale.com/stable/Tailscale-${version}-macos.zip";
        sha256 = "sha256-lPXqzaT//eX1GLemnKEWkGainp4K4fgDesvBjApc+Y8=";
      };

      nativeBuildInputs = [makeWrapper];
      dontFixup = true; # Don't break code signing. Check with `codesign -dv ./result/Applications/Tailscale.app`
      installPhase = ''
        mkdir -p "$out/Applications/${app}" "$out/bin"
        cp -R . "$out/Applications/${app}"
        makeWrapper \
          "$out/Applications/${app}/Contents/MacOS/Tailscale" \
          "$out/bin/tailscale"
      '';

      # The stable channel publishes its current version as JSON; nix-update
      # then refetches the macOS zip to update the hash.
      passthru.updateScript = writeScript "update-tailscale" ''
        #!/usr/bin/env nix-shell
        #!nix-shell -i bash -p nix-update curl jq
        set -euo pipefail
        version="$(curl -fsSL 'https://pkgs.tailscale.com/stable/?mode=json' | jq -r .Version)"
        nix-update --flake tailscale --version "$version"
      '';

      meta = {
        description = "The node agent for Tailscale, a mesh VPN built on WireGuard";
        homepage = "https://tailscale.com";
        license = lib.licenses.bsd3;
      };
    }

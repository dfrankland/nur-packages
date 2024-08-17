{ lib, stdenv, fetchzip, tailscale, makeWrapper }:

if (!stdenv.isDarwin) then
  tailscale
else
# https://pkgs.tailscale.com/stable/#macos
  let
    app = "Tailscale.app";
    version = "1.70.0";
  in
  stdenv.mkDerivation rec {
    pname = "tailscale";
    inherit version;

    src = fetchzip {
      url = "https://pkgs.tailscale.com/stable/Tailscale-${version}-macos.zip";
      sha256 = "sha256-vorCFF2TI5A6M41JkmPeGoriQ9eTSQGc56pYAqTHikM=";
    };

    nativeBuildInputs = [ makeWrapper ];

    installPhase = ''
      mkdir -p "$out/Applications/${app}" "$out/bin"
      cp -R . "$out/Applications/${app}"
      makeWrapper \
        "$out/Applications/${app}/Contents/MacOS/Tailscale" \
        "$out/bin/tailscale"
    '';

    meta = {
      description = "The node agent for Tailscale, a mesh VPN built on WireGuard";
      homepage = "https://tailscale.com";
      license = lib.licenses.bsd3;
    };
  }

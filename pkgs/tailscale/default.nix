{ lib, stdenv, fetchzip, tailscale }:


if (!stdenv.isDarwin) then
  tailscale
else
  let
    app = "Tailscale.app";
    version = "1.34.2";
  in
  stdenv.mkDerivation rec {
    pname = "tailscale";
    inherit version;

    src = fetchzip {
      url = "https://pkgs.tailscale.com/stable/Tailscale-${version}-macos.zip";
      sha256 = "sha256-TDpjB4H2150dYzRQrv76eaoNhHzpHD8nCQxmRVFogQM=";
    };

    installPhase = ''
      mkdir -p $out/Applications/${app} $out/bin
      cp -R . $out/Applications/${app}
      ln -s $out/Applications/${app}/Contents/MacOS/Tailscale $out/bin/tailscale
    '';

    meta = {
      description = "The node agent for Tailscale, a mesh VPN built on WireGuard";
      homepage = "https://tailscale.com";
      license = lib.licenses.bsd3;
    };
  }

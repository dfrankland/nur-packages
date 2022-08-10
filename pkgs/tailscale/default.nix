{ lib, stdenv, fetchzip, tailscale }:


if (!stdenv.isDarwin) then
  tailscale
else
  let
    app = "Tailscale.app";
    version = "1.28.0";
  in
  stdenv.mkDerivation rec {
    pname = "tailscale";
    inherit version;

    src = fetchzip {
      url = "https://pkgs.tailscale.com/stable/Tailscale-${version}-macos.zip";
      sha256 = "sha256-s9I/pO3Y2GUC4B9XE8oPT8omtJFZn9D5g1lLJXYEdSM=";
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

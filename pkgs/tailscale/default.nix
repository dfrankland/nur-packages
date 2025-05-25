{ lib, stdenv, fetchzip, tailscale, makeWrapper }:

if (!stdenv.isDarwin) then
  tailscale
else
# https://pkgs.tailscale.com/stable/#macos
  let
    app = "Tailscale.app";
    version = "1.84.0";
  in
  stdenv.mkDerivation rec {
    pname = "tailscale";
    inherit version;

    src = fetchzip {
      url = "https://pkgs.tailscale.com/stable/Tailscale-${version}-macos.zip";
      sha256 = "sha256-JPrLxTzi8Lg1IQYKbX+JUB6C8aNSEZSsMOvepEYU5Bw=";
    };

    nativeBuildInputs = [ makeWrapper ];
    dontFixup = true; # Don't break code signing. Check with `codesign -dv ./result/Applications/Tailscale.app`
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

{ lib, stdenv, fetchFromGitHub, nodejs_20, cacert, caddy, makeWrapper }:

let
  version = "2024.02.24-beta1";
  pname = "headscale-ui";
in
stdenv.mkDerivation rec {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "gurucomputing";
    repo = pname;
    rev = version;
    sha256 = "sha256-jbyy8W/qAso2yb/hNsmVHiT0mJXInpEIejU+3IB9wJY=";
  };

  nativeBuildInputs = [ nodejs_20 cacert makeWrapper ];

  buildPhase = ''
    export HOME=$PWD
    npm install
    substituteInPlace src/routes/settings.html/+page.svelte --replace "insert-version" "${version}"
    npm run build
  '';

  installPhase = ''
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
  '';

  meta = {
    description = "A web frontend for the headscale Tailscale-compatible coordination server";
    homepage = "https://github.com/gurucomputing/headscale-ui";
    license = lib.licenses.bsd3;
  };
}

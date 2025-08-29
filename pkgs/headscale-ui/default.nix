{ lib, fetchFromGitHub, caddy, makeWrapper, buildNpmPackage }:

# https://github.com/gurucomputing/headscale-ui/releases
let
  version = "2025.07.12";
  pname = "headscale-ui";
in
buildNpmPackage rec {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "gurucomputing";
    repo = pname;
    rev = version;
    sha256 = "sha256-8hn7F3dw+kIHn9tq+BpEOisQElH6QwYg6n3knz/7r1c=";
  };

  npmDepsHash = "sha256-r8MuY7yhjek2SZyJCv5Xhk9dJE2VgKx7RTdOBr0Bji4=";

  nativeBuildInputs = [ makeWrapper ];

  npmInstallFlags = [ "--logs-max=0" ];

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

  meta = {
    description = "A web frontend for the headscale Tailscale-compatible coordination server";
    homepage = "https://github.com/gurucomputing/headscale-ui";
    license = lib.licenses.bsd3;
  };
}

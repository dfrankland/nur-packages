{ lib, fetchFromGitHub, caddy, makeWrapper, buildNpmPackage }:

let
  version = "2025.05.22";
  pname = "headscale-ui";
in
buildNpmPackage rec {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "gurucomputing";
    repo = pname;
    rev = version;
    sha256 = "sha256-/wDk/ENZSgffDEEat13Yob+NmVuJF4bOPeE0XhwgC9Y=";
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

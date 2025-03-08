{ lib, fetchFromGitHub, caddy, makeWrapper, buildNpmPackage }:

let
  version = "2025.01.20";
  pname = "headscale-ui";
in
buildNpmPackage rec {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "gurucomputing";
    repo = pname;
    rev = version;
    sha256 = "sha256-I+kPzVxLwZ3Gw0oLro8j6p7D+n81mbPZ5t2wDcNP0lA=";
  };

  npmDepsHash = "sha256-lUSk62YQTFnaIjgz4vZm5By3xffY7+8GqPftS7b5d/Y=";

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

{ lib, stdenv, fetchurl, undmg }:

let
  app = "Drata Agent.app";
  version = "3.4.1";
in
stdenv.mkDerivation {
  pname = "drata-agent";
  inherit version;

  src = fetchurl {
    url = "https://cdn.drata.com/agent/dist/mac/drata-agent-3.4.1.dmg";
    sha256 = "sha256-u3Z2M2WDZ71PgeXwNDoe64sSlXg0Pocm1ms40ZqS/Uc=";
  };

  sourceRoot = app;

  buildInputs = [ undmg ];
  installPhase = ''
    mkdir -p "$out/Applications/${app}"
    cp -R . "$out/Applications/${app}"
  '';

  meta = {
    description = "Drata compliance agent";
    homepage = "https://app.drata.com/employee/install-agent";
    license = lib.licenses.unfree;
    platforms = lib.platforms.darwin;
  };
}

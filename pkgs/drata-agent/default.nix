{ lib, stdenv, fetchurl, unpackdmg }:

let
  app = "Drata Agent.app";
  version = "3.8.0";
in
stdenv.mkDerivation {
  pname = "drata-agent";
  inherit version;

  src = fetchurl {
    url = "https://github.com/drata/agent-releases/releases/download/${version}/Drata-Agent-mac.dmg";
    sha256 = "sha256-SGodojTQBZraDClHwEHpUSD4lTTgcLHXPORQPSrfYi0=";
  };

  buildInputs = [ unpackdmg ];
  dontFixup = true; # Don't break code signing. Check with `codesign -dv ./result/Applications/Drata\ Agent.app`
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

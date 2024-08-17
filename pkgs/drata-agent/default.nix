{ lib, stdenv, fetchurl, unpackdmg }:

let
  app = "Drata Agent.app";
  version = "3.6.1";
in
stdenv.mkDerivation {
  pname = "drata-agent";
  inherit version;

  src = fetchurl {
    url = "https://github.com/drata/agent-releases/releases/download/v${version}/Drata-Agent-mac.dmg";
    sha256 = "sha256-lmo60SDvTUa4RbaIKFnkQOWNdbVKLrRtUYgTCXWZHt4=";
  };

  buildInputs = [ unpackdmg ];
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

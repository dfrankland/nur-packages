{ lib, stdenv, fetchzip, undmg }:

let
  app = "QMK Toolbox.app";
  version = "0.2.2";
in
stdenv.mkDerivation rec {
  pname = "qmk_toolbox";
  inherit version;

  src = fetchzip {
    url = "https://github.com/qmk/qmk_toolbox/releases/download/${version}/QMK.Toolbox.app.zip";
    sha256 = "sha256-+kIX6qQbzxcfrxAvo6TPsum56T9ym9iQwpDxbMzvDJM=";
  };

  buildInputs = [ undmg ];
  installPhase = ''
    mkdir -p "$out/Applications/${app}"
    cp -R . "$out/Applications/${app}"
  '';

  meta = {
    description = "A Toolbox companion for QMK Firmware";
    homepage = "https://github.com/qmk/qmk_toolbox";
    license = lib.licenses.mit;
    platforms = lib.platforms.darwin;
  };
}

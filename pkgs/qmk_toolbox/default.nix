{ lib, stdenv, fetchzip, undmg }:

let
  app = "QMK Toolbox.app";
  version = "0.3.0";
in
stdenv.mkDerivation rec {
  pname = "qmk_toolbox";
  inherit version;

  src = fetchzip {
    url = "https://github.com/qmk/qmk_toolbox/releases/download/${version}/QMK.Toolbox.app.zip";
    sha256 = "sha256-mpso3gUXs+KkufdH7gh4OJ28rfp4jaH/T0jaijk5x0U=";
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

{ lib, stdenv, fetchzip, undmg }:

let
  app = "QMK Toolbox.app";
  version = "0.1.1";
in
stdenv.mkDerivation rec {
  pname = "qmk_toolbox";
  inherit version;

  src = fetchzip {
    url = "https://github.com/qmk/qmk_toolbox/releases/download/${version}/QMK.Toolbox.app.zip";
    sha256 = "sha256-Wt3Q9F3HhrKczkSGRCiBfPSNDxvpUy4Gm8VJt6aXwPA=";
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

{ lib, stdenv, fetchurl, undmg }:

# https://formulae.brew.sh/api/cask/rippling.json
let
  app = "Rippling.app";
  version = "3.6.44";
in
stdenv.mkDerivation {
  pname = "rippling";
  inherit version;

  src = fetchurl {
    url = "https://hardware-cdn.rippling.com/device_release/electron-installer/${version}/macos/Rippling.dmg";
    sha256 = "sha256-k0Ua2jLhxxq3AbCazQen+l2tLnDF2O2Imq9XMdDu/CE=";
  };

  sourceRoot = app;

  buildInputs = [ undmg ];
  dontFixup = true; # Don't break code signing. Check with `codesign -dv ./result/Applications/Rippling.app`
  installPhase = ''
    mkdir -p "$out/Applications/${app}"
    cp -R . "$out/Applications/${app}"
  '';

  meta = {
    description = "Rippling device management";
    homepage = "https://app.rippling.com/downloads/hardware-management/";
    license = lib.licenses.unfree;
    platforms = lib.platforms.darwin;
  };
}

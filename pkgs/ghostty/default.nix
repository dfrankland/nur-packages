{ lib, stdenv, fetchurl, unpackdmg, makeWrapper, ghostty }:

if (!stdenv.isDarwin) then
  ghostty
else
# https://formulae.brew.sh/api/cask/ghostty.json
  let
    app = "Ghostty.app";
    version = "1.1.3";
  in
  stdenv.mkDerivation {
    pname = "ghostty";
    inherit version;

    src = fetchurl {
      url = "https://release.files.ghostty.org/${version}/Ghostty.dmg";
      sha256 = "sha256-ZOUUGI9UlZjxZtbctvjfKfMz6VTigXKikB6piKFPJkc=";
    };

    buildInputs = [ unpackdmg ];
    nativeBuildInputs = [ makeWrapper ];
    installPhase = ''
      mkdir -p "$out/Applications/${app}"
      cp -R . "$out/Applications/${app}"
      makeWrapper \
        "$out/Applications/${app}/Contents/MacOS/ghostty" \
        "$out/bin/ghostty"
    '';

    meta = {
      description = "Terminal emulator that uses platform-native UI and GPU acceleration";
      homepage = "https://ghostty.org/";
      license = lib.licenses.mit;
      platforms = lib.platforms.darwin;
    };
  }

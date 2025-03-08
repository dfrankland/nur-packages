{ lib, stdenv, fetchurl, unpackdmg, github-desktop, makeWrapper, ghostty }:

if (!stdenv.isDarwin) then
  ghostty
else
# https://formulae.brew.sh/api/cask/ghostty.json
  let
    app = "Ghostty.app";
    version = "1.1.2";
  in
  stdenv.mkDerivation {
    pname = "ghostty";
    inherit version;

    src = fetchurl {
      url = "https://release.files.ghostty.org/${version}/Ghostty.dmg";
      sha256 = "sha256-1K0BOWg0ykR/pdCE6/b7XUSVcoD6ryLqRz6WBnUcSOE=";
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

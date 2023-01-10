{ lib, stdenv, fetchzip, undmg, wezterm }:

if (!stdenv.isDarwin) then
  wezterm
else
  let
    app = "WezTerm.app";
    version = "20221119-145034-49b9839f";
  in
  stdenv.mkDerivation rec {
    pname = "wezterm";
    inherit version;

    src = fetchzip {
      url = "https://github.com/wez/wezterm/releases/download/${version}/WezTerm-macos-${version}.zip";
      sha256 = "sha256-SSVEP5h3eq7kw+4ohbPD7YCe60AZyvM8Ks7RYPFvAYE=";
    };

    buildInputs = [ undmg ];
    installPhase = ''
      mkdir -p "$out/Applications/"
      cp -R . "$out/Applications/"
    '';

    meta = {
      description = "A GPU-accelerated cross-platform terminal emulator and multiplexer written by @wez and implemented in Rust";
      homepage = "https://wezfurlong.org/wezterm";
      changelog = "https://wezfurlong.org/wezterm/changelog.html#${version}";
      license = lib.licenses.mit;
      platforms = lib.platforms.darwin;
    };
  }

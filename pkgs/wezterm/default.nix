{ lib, stdenv, fetchzip, undmg, wezterm }:

if (!stdenv.isDarwin) then
  wezterm
else
  let
    app = "WezTerm.app";
    version = "20220319-142410-0fcdea07";
  in
  stdenv.mkDerivation rec {
    pname = "wezterm";
    inherit version;

    src = fetchzip {
      url = "https://github.com/wez/wezterm/releases/download/${version}/WezTerm-macos-${version}.zip";
      sha256 = "sha256-hE6GnXSbHQBiOtuCsdhjO2VdxhpzQJSSt/g0Nwwry1Q=";
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

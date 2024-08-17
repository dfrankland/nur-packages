{ lib, stdenv, fetchzip, undmg, wezterm }:

if (!stdenv.isDarwin) then
  wezterm
else
  let
    version = "20240203-110809-5046fc22";
  in
  stdenv.mkDerivation rec {
    pname = "wezterm";
    inherit version;

    src = fetchzip {
      url = "https://github.com/wez/wezterm/releases/download/${version}/WezTerm-macos-${version}.zip";
      sha256 = "sha256-HKUC7T7VJ+3dDtbOoFc/kVUBUGstsAZn+IpD9oRIMXw=";
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

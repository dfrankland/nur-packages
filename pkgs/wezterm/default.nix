{
  lib,
  stdenv,
  fetchzip,
  undmg,
  wezterm,
  writeScript,
}:
if (!stdenv.isDarwin)
then wezterm
else let
  version = "20240203-110809-5046fc22";
in
  stdenv.mkDerivation rec {
    pname = "wezterm";
    inherit version;

    src = fetchzip {
      url = "https://github.com/wez/wezterm/releases/download/${version}/WezTerm-macos-${version}.zip";
      sha256 = "sha256-HKUC7T7VJ+3dDtbOoFc/kVUBUGstsAZn+IpD9oRIMXw=";
    };

    buildInputs = [undmg];
    installPhase = ''
      mkdir -p "$out/Applications/"
      cp -R . "$out/Applications/"
    '';

    # Releases are published on GitHub (wez/wezterm); nix-update reads the latest
    # (non-prerelease) tag from there, skipping the `nightly` builds.
    passthru.updateScript = writeScript "update-wezterm" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p nix-update
      set -euo pipefail
      nix-update --flake wezterm
    '';

    meta = {
      description = "A GPU-accelerated cross-platform terminal emulator and multiplexer written by @wez and implemented in Rust";
      homepage = "https://wezfurlong.org/wezterm";
      changelog = "https://wezfurlong.org/wezterm/changelog.html#${version}";
      license = lib.licenses.mit;
      platforms = ["aarch64-darwin"];
    };
  }

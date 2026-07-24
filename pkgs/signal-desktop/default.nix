{
  lib,
  stdenv,
  fetchurl,
  unpackdmg,
  signal-desktop,
  writeScript,
}:
if (!stdenv.isDarwin)
then signal-desktop
else
  # https://formulae.brew.sh/api/cask/signal.json
  let
    app = "Signal.app";
    version = "8.20.0";
  in
    stdenv.mkDerivation {
      pname = "signal-desktop";
      inherit version;

      src = fetchurl {
        url = "https://updates.signal.org/desktop/signal-desktop-mac-universal-${version}.dmg";
        sha256 = "sha256-FExYa0PpB5jmhtOznqOaY2XO8ogTqpcvDiSIHSvvi3o=";
      };

      sourceRoot = app;

      dontFixup = true; # Don't break code signing. Check with `codesign -dv ./result/Applications/Signal.app`
      buildInputs = [unpackdmg];
      installPhase = ''
        mkdir -p "$out/Applications/${app}"
        cp -R . "$out/Applications/${app}"
      '';

      # There is no upstream version feed, so track the Homebrew cask; nix-update
      # then refetches the dmg to update the hash.
      passthru.updateScript = writeScript "update-signal-desktop" ''
        #!/usr/bin/env nix-shell
        #!nix-shell -i bash -p nix-update curl jq
        set -euo pipefail
        version="$(curl -fsSL https://formulae.brew.sh/api/cask/signal.json | jq -r .version)"
        nix-update --flake signal-desktop --version "$version"
      '';

      meta = {
        description = "Private, simple, and secure messenger";
        longDescription = ''
          Signal Desktop is an Electron application that links with your
          "Signal Android" or "Signal iOS" app.
        '';
        homepage = "https://signal.org/";
        changelog = "https://github.com/signalapp/Signal-Desktop/releases/tag/v${version}";
        license = lib.licenses.agpl3Only;
        platforms = ["aarch64-darwin"];
      };
    }

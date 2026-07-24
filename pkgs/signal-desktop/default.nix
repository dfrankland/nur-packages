{
  lib,
  stdenv,
  fetchzip,
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

      src = fetchzip {
        url = "https://updates.signal.org/desktop/signal-desktop-mac-arm64-${version}.zip";
        sha256 = "sha256-T7og6DAfiWMlT3Ko5U86iuX36+5W+BSd8lZiLhM1WFU=";
      };

      dontFixup = true; # Don't break code signing. Check with `codesign -dv ./result/Applications/Signal.app`
      installPhase = ''
        mkdir -p "$out/Applications/${app}"
        cp -R . "$out/Applications/${app}"
      '';

      # There is no upstream version feed, so track the Homebrew cask; nix-update
      # then refetches the zip to update the hash.
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

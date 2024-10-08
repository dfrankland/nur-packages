{ lib, stdenv, fetchurl, undmg, signal-desktop }:

if (!stdenv.isDarwin) then
  signal-desktop
else
# https://formulae.brew.sh/api/cask/signal.json
  let
    app = "Signal.app";
    version = "7.20.0";
  in
  stdenv.mkDerivation {
    pname = "signal-desktop";
    inherit version;

    src = fetchurl {
      url = "https://updates.signal.org/desktop/signal-desktop-mac-universal-${version}.dmg";
      sha256 = "sha256-O4Nf4zFW8QkkspMSY6pSHQ0zxMyb3UYlKdqWzmYtGsY=";
    };

    sourceRoot = app;

    buildInputs = [ undmg ];
    installPhase = ''
      mkdir -p "$out/Applications/${app}"
      cp -R . "$out/Applications/${app}"
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
      platforms = lib.platforms.darwin;
    };
  }

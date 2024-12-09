{ lib, stdenv, fetchurl, unpackdmg, signal-desktop }:

if (!stdenv.isDarwin) then
  signal-desktop
else
# https://formulae.brew.sh/api/cask/signal.json
  let
    app = "Signal.app";
    version = "7.35.1";
  in
  stdenv.mkDerivation {
    pname = "signal-desktop";
    inherit version;

    src = fetchurl {
      url = "https://updates.signal.org/desktop/signal-desktop-mac-universal-${version}.dmg";
      sha256 = "sha256-2AP9CZ+Ob/o/yA9c4CwFEgQt5zUiyCzEmIRPZtjvcC0=";
    };

    sourceRoot = app;

    buildInputs = [ unpackdmg ];
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

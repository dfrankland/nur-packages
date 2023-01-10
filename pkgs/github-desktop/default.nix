{ lib, stdenv, fetchzip, undmg, github-desktop }:

if (!stdenv.isDarwin) then
  github-desktop
else
  let
    app = "GitHub Desktop.app";
    version = "3.1.3";
    versionCommit = "${version}-4731f276";
    cpu = if (stdenv.hostPlatform.isAarch64) then "arm64" else "x64";
    sha256 = if (stdenv.hostPlatform.isAarch64) then "sha256-bFX7eaRit9HIN0ydFIy/tW7Rx53y5ICozYejKKCiWXY=" else "sha256-bFX7eaRit9HIN0ydFIy/tW7Rx53y5ICozYejKKCiWXY=";
  in
  stdenv.mkDerivation rec {
    pname = "github-desktop";
    inherit version;

    src = fetchzip {
      url = "https://desktop.githubusercontent.com/github-desktop/releases/${versionCommit}/GitHubDesktop-${cpu}.zip";
      inherit sha256;
    };

    buildInputs = [ undmg ];
    installPhase = ''
      mkdir -p "$out/Applications/${app}"
      cp -R . "$out/Applications/${app}"
    '';

    meta = {
      description = "GUI for managing Git and GitHub.";
      homepage = "https://desktop.github.com/";
      license = lib.licenses.mit;
      platforms = lib.platforms.darwin;
    };
  }

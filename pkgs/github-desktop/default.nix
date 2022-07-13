{ lib, stdenv, fetchzip, undmg, github-desktop }:

if (!stdenv.isDarwin) then
  github-desktop
else
  let
    app = "GitHub Desktop.app";
    version = "3.0.4";
    versionCommit = "${version}-06c9bb7f";
    cpu = if (stdenv.hostPlatform.isAarch64) then "arm64" else "x64";
    sha256 = if (stdenv.hostPlatform.isAarch64) then "sha256-+4d/bIuTGfoas00fBklar3rZofS1d4gDYPpnK3osaSw=" else "sha256-Is2fGXP7wjdROZAIWOAUYSSSeQtmuQKo2RlP1r6JaP4=";
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

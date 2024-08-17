{ lib, stdenv, fetchzip, undmg, github-desktop }:

if (!stdenv.isDarwin) then
  github-desktop
else
# https://formulae.brew.sh/api/cask/github.json
  let
    app = "GitHub Desktop.app";
    version = "3.4.3";
    versionCommit = "${version}-2170ce9b";
    cpu = if (stdenv.hostPlatform.isAarch64) then "arm64" else "x64";
    sha256 =
      if (stdenv.hostPlatform.isAarch64)
      then "sha256-77a9tsksCGitIyAea8iEt4B3V/BlKkyZ5qHyrStKz7w="
      else "sha256-tvHMhey5L9JcVd3rnfIGyn+gO/CUwvHRv7o0EztME5Q=";
  in
  stdenv.mkDerivation {
    pname = "github-desktop";
    inherit version;

    src = fetchzip {
      url = "https://desktop.githubusercontent.com/releases/${versionCommit}/GitHubDesktop-${cpu}.zip";
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

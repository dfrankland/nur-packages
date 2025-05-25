{ lib, stdenv, fetchzip, undmg, github-desktop, makeWrapper }:

if (!stdenv.isDarwin) then
  github-desktop
else
# https://formulae.brew.sh/api/cask/github.json
  let
    app = "GitHub Desktop.app";
    version = "3.4.20";
    versionCommit = "${version}-d2e01c60";
    cpu = if (stdenv.hostPlatform.isAarch64) then "arm64" else "x64";
    sha256 =
      if (stdenv.hostPlatform.isAarch64)
      then "sha256-yjAKvvhn+m16UcjEySMLvZcyub8YhxfztQA53EDULXw="
      else "sha256-1T7Wn/hLiI9keCPA05jSJ7zp7YHFqb6R2r7CwsfJ9j4=";
  in
  stdenv.mkDerivation {
    pname = "github-desktop";
    inherit version;

    src = fetchzip {
      url = "https://desktop.githubusercontent.com/releases/${versionCommit}/GitHubDesktop-${cpu}.zip";
      inherit sha256;
    };

    buildInputs = [ undmg ];
    nativeBuildInputs = [ makeWrapper ];
    installPhase = ''
      mkdir -p "$out/Applications/${app}"
      cp -R . "$out/Applications/${app}"
      wrapProgram "$out/Applications/${app}/Contents/Resources/app/git/bin/git" --set GIT_EXEC_PATH "$out/Applications/${app}/Contents/Resources/app/git/libexec/git-core"
      wrapProgram "$out/Applications/${app}/Contents/Resources/app/git/libexec/git-core/git" --set GIT_EXEC_PATH "$out/Applications/${app}/Contents/Resources/app/git/libexec/git-core"
    '';

    meta = {
      description = "GUI for managing Git and GitHub.";
      homepage = "https://desktop.github.com/";
      license = lib.licenses.mit;
      platforms = lib.platforms.darwin;
    };
  }

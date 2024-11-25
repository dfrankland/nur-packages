{ lib, stdenv, fetchzip, undmg, github-desktop, makeWrapper }:

if (!stdenv.isDarwin) then
  github-desktop
else
# https://formulae.brew.sh/api/cask/github.json
  let
    app = "GitHub Desktop.app";
    version = "3.4.9";
    versionCommit = "${version}-5be94b37";
    cpu = if (stdenv.hostPlatform.isAarch64) then "arm64" else "x64";
    sha256 =
      if (stdenv.hostPlatform.isAarch64)
      then "sha256-cB5XMw4/QdqDDRFVSdxg4bEKpzEa2X0vFbAZyIYBBzM="
      else "sha256-8SMQRO5BB/PlOhwMv49+ZMmjuAg39DgbUZ16GEn667Y=";
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

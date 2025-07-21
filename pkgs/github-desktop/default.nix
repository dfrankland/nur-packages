{ lib, stdenv, fetchzip, undmg, github-desktop, makeWrapper }:

if (!stdenv.isDarwin) then
  github-desktop
else
# https://formulae.brew.sh/api/cask/github.json
  let
    app = "GitHub Desktop.app";
    version = "3.5.2";
    versionCommit = "${version}-14087268";
    cpu = if (stdenv.hostPlatform.isAarch64) then "arm64" else "x64";
    sha256 =
      if (stdenv.hostPlatform.isAarch64)
      then "sha256-j9sF89i6CfeYFGhg6+NFldLaKr0OK67IH/rOAHAc/nY="
      else "sha256-KLeEXjg0vK9yV33JZjCr9CREgBUqco4lQNx/wkevUck=";
  in
  stdenv.mkDerivation {
    pname = "github-desktop";
    inherit version;

    src = fetchzip {
      url = "https://desktop.githubusercontent.com/releases/${versionCommit}/GitHubDesktop-${cpu}.zip";
      inherit sha256;
    };
    dontFixup = true; # Don't break code signing. Check with `codesign -dv ./result/Applications/GitHub\ Desktop.app`

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

{
  lib,
  stdenv,
  fetchzip,
  undmg,
  github-desktop,
  makeWrapper,
  writeScript,
}:
if (!stdenv.isDarwin)
then github-desktop
else
  # https://formulae.brew.sh/api/cask/github.json
  let
    app = "GitHub Desktop.app";
    # The download path is keyed by "<version>-<build>", which is exactly what
    # the Homebrew cask reports as its version, so we pin the whole string.
    version = "3.6.3-931da4a1";
    cpu = "arm64";
    sha256 = "sha256-M7IL5xtPuErwT5WqBOfjUaoUogFxQpFSXgi8h77joho=";
  in
    stdenv.mkDerivation {
      pname = "github-desktop";
      inherit version;

      src = fetchzip {
        url = "https://desktop.githubusercontent.com/releases/${version}/GitHubDesktop-${cpu}.zip";
        inherit sha256;
      };
      dontFixup = true; # Don't break code signing. Check with `codesign -dv ./result/Applications/GitHub\ Desktop.app`

      buildInputs = [undmg];
      nativeBuildInputs = [makeWrapper];
      installPhase = ''
        mkdir -p "$out/Applications/${app}"
        cp -R . "$out/Applications/${app}"
        wrapProgram "$out/Applications/${app}/Contents/Resources/app/git/bin/git" --set GIT_EXEC_PATH "$out/Applications/${app}/Contents/Resources/app/git/libexec/git-core"
        wrapProgram "$out/Applications/${app}/Contents/Resources/app/git/libexec/git-core/git" --set GIT_EXEC_PATH "$out/Applications/${app}/Contents/Resources/app/git/libexec/git-core"
      '';

      # There is no upstream version feed, so track the Homebrew cask (whose
      # version is already the "<version>-<build>" string we pin); nix-update
      # then refetches the zip to update the (fetchzip) hash.
      passthru.updateScript = writeScript "update-github-desktop" ''
        #!/usr/bin/env nix-shell
        #!nix-shell -i bash -p nix-update curl jq
        set -euo pipefail
        version="$(curl -fsSL https://formulae.brew.sh/api/cask/github.json | jq -r .version)"
        nix-update --flake github-desktop --version "$version"
      '';

      meta = {
        description = "GUI for managing Git and GitHub.";
        homepage = "https://desktop.github.com/";
        license = lib.licenses.mit;
        platforms = ["aarch64-darwin"];
      };
    }

{ lib, stdenv, fetchzip, undmg, github-desktop }:

if (!stdenv.isDarwin) then
  github-desktop
else
  let
    app = "GitHub Desktop.app";
    version = "3.3.3";
    versionCommit = "${version}-abf8a692";
    cpu = if (stdenv.hostPlatform.isAarch64) then "arm64" else "x64";
    sha256 =
      if (stdenv.hostPlatform.isAarch64)
      then "sha256-DWOhY7rasW61nTi6vRoEYGLfXFN0Kz+OWHlv5euEFy4="
      else "sha256-Vt1QyVsbFwcxDbSwi3J/KUUSOOtKkElqwPUViHStsVE=";
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

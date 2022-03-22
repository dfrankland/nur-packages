{ lib, stdenv, fetchzip, undmg, github-desktop }:

if (!stdenv.isDarwin) then
  github-desktop
else
  let
    app = "GitHub Desktop.app";
    version = "2.9.11";
    versionCommit = "${version}-93911c1f";
    isArm = with stdenv.hostPlatform; isAarch64 || isAarch32;
    cpu = if (isArm) then "arm64" else "x64";
    sha256 = if (isArm) then "sha256-NWXkEI06mzsVLXosJ9eeowDYpthvExgc7qaAdMZMRqk=" else "sha256-fn6eIzjrxKXos68wwKUkjw6mQDZKm/ZbuPKNicnEXVA=";
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

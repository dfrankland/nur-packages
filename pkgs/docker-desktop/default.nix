{
  lib,
  stdenv,
  fetchurl,
  unpackdmg,
  dpkg,
  makeWrapper,
  writeScript,
}: let
  # get the lastest version from https://docs.docker.com/desktop/release-notes/
  version = "4.83.0";
  rev = "234302";
  platform =
    if (stdenv.isDarwin)
    then "mac"
    else "linux";
  cpu =
    if (stdenv.isDarwin)
    then "arm64"
    else "amd64";
  sha256 =
    if (platform == "mac" && cpu == "arm64")
    then "6d0798ee8b93bbb742e2eac5e6bab9aa95021498f73b95b9e4e9c6c6b6a71bf5"
    else "62d02dfec99043c7d972c1af9b4012e319b94ca1f1f40ac4d89b199985ed4f46";
  file =
    if (stdenv.isDarwin)
    then "Docker.dmg"
    else "docker-desktop-amd64.deb";
  app = "Docker.app";
in
  stdenv.mkDerivation {
    pname = "docker-desktop";
    inherit version;

    src = fetchurl {
      url = "https://desktop.docker.com/${platform}/main/${cpu}/${rev}/${file}";
      inherit sha256;
    };

    nativeBuildInputs =
      if (stdenv.isDarwin)
      then [unpackdmg makeWrapper]
      else [dpkg];
    dontFixup = true; # Don't break code signing. Check with `codesign -dv ./result/Applications/Docker.app`
    installPhase =
      if (stdenv.isDarwin)
      then ''
        mkdir -p "$out/Applications"
        cp -R '${app}' "$out/Applications/"
        makeWrapper \
          "$out/Applications/${app}/Contents/Resources/bin/docker-credential-desktop" \
          "$out/bin/docker-credential-desktop"
        makeWrapper \
          "$out/Applications/${app}/Contents/Resources/bin/docker-credential-osxkeychain" \
          "$out/bin/docker-credential-osxkeychain"
        makeWrapper \
          "$out/Applications/${app}/Contents/Resources/bin/docker" \
          "$out/bin/docker"
      ''
      else ''
        # TODO!
      '';

    # The macOS Sparkle appcast reports both the marketing version
    # (shortVersionString) and the build number (`rev`) used in the download
    # URLs; the same build number serves the Linux deb. Both artifacts are
    # plain files, so their fetchurl hashes are just `sha256sum` of the
    # downloads (hex, matching how they are pinned here).
    passthru.updateScript = writeScript "update-docker-desktop" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p curl gnused coreutils
      set -euo pipefail
      file=pkgs/docker-desktop/default.nix
      appcast="$(curl -fsSL https://desktop.docker.com/mac/main/arm64/appcast.xml)"
      version="$(printf '%s' "$appcast" | grep -oE 'sparkle:shortVersionString="[^"]*"' | head -1 | sed -E 's/.*"([^"]*)".*/\1/')"
      rev="$(printf '%s' "$appcast" | grep -oE 'sparkle:version="[^"]*"' | head -1 | sed -E 's/.*"([^"]*)".*/\1/')"
      mac_path="$(nix-prefetch-url --print-path "https://desktop.docker.com/mac/main/arm64/$rev/Docker.dmg" | tail -1)"
      linux_path="$(nix-prefetch-url --print-path "https://desktop.docker.com/linux/main/amd64/$rev/docker-desktop-amd64.deb" | tail -1)"
      mac_hash="$(sha256sum "$mac_path" | cut -d' ' -f1)"
      linux_hash="$(sha256sum "$linux_path" | cut -d' ' -f1)"
      # Current hashes, in file order: [mac arm64, linux amd64].
      mapfile -t old < <(grep -oE '[0-9a-f]{64}' "$file")
      sed -i \
        -e "s/version = \"[^\"]*\"/version = \"$version\"/" \
        -e "s/rev = \"[^\"]*\"/rev = \"$rev\"/" \
        -e "s/''${old[0]}/$mac_hash/" \
        -e "s/''${old[1]}/$linux_hash/" \
        "$file"
    '';

    meta = with lib; {
      homepage = "https://www.docker.com/products/docker-desktop/";
      description = "Docker Desktop is an easy-to-install application for your Mac or Windows environment that enables you to build and share containerized applications and microservices.";
      license = licenses.unfree;
      platforms = ["x86_64-linux" "aarch64-darwin"];
    };
  }

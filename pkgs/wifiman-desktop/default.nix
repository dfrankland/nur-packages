{
  lib,
  stdenv,
  fetchurl,
  xar,
  cpio,
  writeScript,
}:
# https://formulae.brew.sh/api/cask/wifiman.json
let
  pname = "wifiman-desktop";
  version = "1.2.8";
  system-and-extension =
    if (stdenv.isDarwin)
    then "arm64.pkg"
    else "amd64.deb";
  sha256 =
    if (stdenv.isDarwin)
    then "sha256-To9RqgISIieoyTupquagqnc4cBoKDiMSSHh8JjGewBE="
    else
      # TODO: make this work for linux
      if (stdenv.hostPlatform.isAarch64)
      then lib.fakeSha256
      else lib.fakeSha256;
in
  stdenv.mkDerivation {
    inherit pname version;

    src = fetchurl {
      # https://ui.com/download/app/wifiman-desktop
      url = "https://desktop.wifiman.com/${pname}-${version}-${system-and-extension}";
      inherit sha256;
    };

    nativeBuildInputs = [xar cpio];

    unpackPhase = ''
      runHook preUnpack

      xar -x -f $src
      cd WifimanDesktop.pkg

      runHook postUnpack
    '';

    buildPhase = ''
      runHook preBuild

      cat Payload | gunzip -dc | cpio -i

      runHook postBuild
    '';

    installPhase = ''
      # runHook preInstall

      mkdir -p $out/Applications
      cp -r "WiFiman Desktop.app" $out/Applications/

      runHook postInstall
    '';

    # TODO: This app tries to write files to its own `.app` directory—we might be
    # able to patch it not to do that. Patching will require using `asar` to
    # unpack `WiFiman Desktop.app/Contents/Resources/app.asar`, updating some JS
    # file(s), and repacking it again.
    # patchPhase = "";

    # There is no upstream version feed, so track the Homebrew cask; nix-update
    # then refetches the (aarch64-darwin) pkg to update the hash. The Linux hash
    # is still a TODO placeholder and must be filled in by hand.
    passthru.updateScript = writeScript "update-wifiman-desktop" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p nix-update curl jq
      set -euo pipefail
      version="$(curl -fsSL https://formulae.brew.sh/api/cask/wifiman.json | jq -r .version)"
      nix-update --flake wifiman-desktop --version "$version"
    '';

    meta = {
      homepage = "https://ui.com/download/app/wifiman-desktop";
      description = "Connect remotely to your UniFi network via Teleport VPN.";
      license = lib.licenses.unfree;
      # TODO: make this work for linux
      platforms = ["aarch64-darwin"];
    };
  }

{
  lib,
  stdenv,
  mullvad-vpn,
  fetchurl,
  xar,
  cpio,
  writeScript,
}:
if (!stdenv.isDarwin)
then mullvad-vpn
else let
  pname = "mullvad-vpn";
  version = "2026.3";
in
  stdenv.mkDerivation {
    inherit pname version;

    src = fetchurl {
      url = "https://github.com/mullvad/mullvadvpn-app/releases/download/${version}/MullvadVPN-${version}.pkg";
      sha256 = "sha256-Zi3GfkLqqRW1lMDmjT6Ekn9y94TVoHyahOmWyjWL9iw=";
    };

    nativeBuildInputs = [xar cpio];
    dontFixup = true; # Don't break code signing. Check with `codesign -dv ./result/Applications/Mullvad\ VPN.app`

    unpackPhase = ''
      runHook preUnpack

      xar -x -f $src
      cd net.mullvad.vpn.pkg

      runHook postUnpack
    '';

    buildPhase = ''
      runHook preBuild

      cat Payload | gunzip -dc | cpio -i

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/Applications
      cp -r "Mullvad VPN.app" $out/Applications/
      ln -s "$out/Applications/Mullvad VPN.app/Contents/Resources" $out/bin

      runHook postInstall
    '';

    # The mullvad/mullvadvpn-app repo also hosts Android, installer-downloader,
    # and throwaway `test-*` tags, and the desktop release feed is not the top of
    # releases.atom — so we can't let nix-update pick the tag. Instead ask the
    # GitHub API for the newest non-prerelease tag shaped like the desktop
    # versions (`YYYY.N`) and hand that to nix-update.
    passthru.updateScript = writeScript "update-mullvad-vpn" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p nix-update curl jq
      set -euo pipefail
      version="$(curl -fsSL https://api.github.com/repos/mullvad/mullvadvpn-app/releases?per_page=100 \
        | jq -r 'map(select(.prerelease == false and .draft == false)
                     | .tag_name | select(test("^[0-9]{4}\\.[0-9]+$")))
                 | first')"
      nix-update --flake mullvad-vpn --version "$version"
    '';

    meta = {
      homepage = "https://github.com/mullvad/mullvadvpn-app";
      description = "Client for Mullvad VPN";
      changelog = "https://github.com/mullvad/mullvadvpn-app/blob/${version}/CHANGELOG.md";
      sourceProvenance = [lib.sourceTypes.binaryNativeCode];
      license = lib.licenses.gpl3Only;
    };
  }

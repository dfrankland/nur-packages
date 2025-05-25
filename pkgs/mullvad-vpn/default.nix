{ lib, stdenv, mullvad-vpn, fetchurl, xar, cpio }:

if (!stdenv.isDarwin) then
  mullvad-vpn
else
  let
    pname = "mullvad-vpn";
    version = "2025.6";
  in
  stdenv.mkDerivation {
    inherit pname version;

    src = fetchurl {
      url = "https://github.com/mullvad/mullvadvpn-app/releases/download/${version}/MullvadVPN-${version}.pkg";
      sha256 = "sha256-wvWJm1P4OF2G4P5vrNPPNXLbcWNRIOIW0+jdrwmZuZE=";
    };

    nativeBuildInputs = [ xar cpio ];
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

    meta = {
      homepage = "https://github.com/mullvad/mullvadvpn-app";
      description = "Client for Mullvad VPN";
      changelog = "https://github.com/mullvad/mullvadvpn-app/blob/${version}/CHANGELOG.md";
      sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
      license = lib.licenses.gpl3Only;
    };
  }

{ lib, stdenv, fetchurl, xar, cpio }:

let
  pname = "wifiman-desktop";
  version = "0.3.0";
  system =
    if (stdenv.isDarwin) then
      if (stdenv.hostPlatform.isAarch64) then "mac-arm64" else "mac-x64"
    else
      if (stdenv.hostPlatform.isAarch64) then "linux-arm64" else "linux-amd64";
  sha256 =
    if (stdenv.isDarwin) then
      if (stdenv.hostPlatform.isAarch64) then
        "sha256-R8F5TiDYpyj3kL6ybovb1aMKJR/UIUGdJYn7QMo/r3o="
      else
        lib.fakeSha256
    else
    # TODO: make this work for linux
      if (stdenv.hostPlatform.isAarch64) then lib.fakeSha256 else lib.fakeSha256;
in
stdenv.mkDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://desktop.wifiman.com/${pname}-${version}-${system}.pkg";
    inherit sha256;
  };

  nativeBuildInputs = [ xar cpio ];

  unpackPhase = ''
    runHook preUnpack

    xar -x -f $src
    cd com.ui.wifiman-desktop.pkg

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

  meta = {
    homepage = "https://ui.com/download/app/wifiman-desktop";
    description = "Connect remotely to your UniFi network via Teleport VPN.";
    license = lib.licenses.unfree;
    # TODO: make this work for linux
    platforms = lib.platforms.darwin;
  };
}

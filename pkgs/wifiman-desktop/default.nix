{ lib, stdenv, fetchurl, xar, cpio }:

# https://formulae.brew.sh/api/cask/wifiman.json
let
  pname = "wifiman-desktop";
  version = "1.1.3";
  system-and-extension =
    if (stdenv.isDarwin) then
      if (stdenv.hostPlatform.isAarch64) then "arm64.pkg" else "amd64.pkg"
    else
      "amd64.deb";
  sha256 =
    if (stdenv.isDarwin) then
      if (stdenv.hostPlatform.isAarch64) then
        "sha256-ztseElREIvKh8m+Wrw+tEbNgZYKVGCtAI/GyisUpekY="
      else
        "sha256-ygddarbo5TMSR8C2DEKVRWo5T+z8a8KcI1cThhlL9g4="
    else
    # TODO: make this work for linux
      if (stdenv.hostPlatform.isAarch64) then lib.fakeSha256 else lib.fakeSha256;
in
stdenv.mkDerivation {
  inherit pname version;

  src = fetchurl {
    # https://ui.com/download/app/wifiman-desktop
    url = "https://desktop.wifiman.com/${pname}-${version}-${system-and-extension}";
    inherit sha256;
  };

  nativeBuildInputs = [ xar cpio ];

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

  meta = {
    homepage = "https://ui.com/download/app/wifiman-desktop";
    description = "Connect remotely to your UniFi network via Teleport VPN.";
    license = lib.licenses.unfree;
    # TODO: make this work for linux
    platforms = lib.platforms.darwin;
  };
}

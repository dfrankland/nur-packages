{
  lib,
  stdenv,
  fetchurl,
  unpackdmg,
  appimageTools,
  writeScript,
}:
# https://formulae.brew.sh/api/cask/epilogue-playback.json
let
  version = "1.10.0";
  urlArch =
    if (stdenv.isDarwin)
    then "macos"
    else "linux";
  urlFile =
    if (stdenv.isDarwin)
    then "Playback.dmg"
    else if (stdenv.isAarch64)
    then "Playback.arm64.AppImage"
    else "Playback.AppImage";
  sha256 =
    if (stdenv.isDarwin)
    then "sha256-+iCAREQqY0GgTBc1TK8BiGchfObLNRgMXsXw8La0tl4="
    else if (stdenv.isAarch64)
    then lib.fakeSha256
    else lib.fakeSha256;
  pname = "epilogue-playback";
  src = fetchurl {
    url = "https://releases.epilogue.co/desktop/playback/${version}/release/${urlArch}/${urlFile}";
    inherit sha256;
  };
  meta = {
    description = "Play and manage Game Boy cartridges on your computer";
    homepage = "https://www.epilogue.co/";
    license = lib.licenses.unfree;
    platforms = lib.platforms.unix;
  };
  # There is no upstream version feed, so track the Homebrew cask; nix-update
  # then refetches the (current system's) artifact to update the hash. The Linux
  # hashes are still fakeSha256 placeholders and must be filled in by hand.
  updateScript = writeScript "update-epilogue-playback" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p nix-update curl jq
    set -euo pipefail
    version="$(curl -fsSL https://formulae.brew.sh/api/cask/epilogue-playback.json | jq -r .version)"
    nix-update --flake epilogue-playback --version "$version"
  '';
in
  if (stdenv.isDarwin)
  then
    stdenv.mkDerivation
    {
      inherit pname version src meta;

      passthru = {inherit updateScript;};
      buildInputs = [unpackdmg];
      installPhase = ''
        mkdir -p "$out/Applications"
        cp -R "Playback.app" "$out/Applications/"
      '';
    }
  else
    appimageTools.wrapType2 {
      inherit pname version src meta;
      passthru = {inherit updateScript;};
    }

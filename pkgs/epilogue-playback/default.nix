{ lib, stdenv, fetchurl, unpackdmg, appimageTools }:

# https://formulae.brew.sh/api/cask/epilogue-playback.json
let
  version = "1.8.0";
  urlArch = if (stdenv.isDarwin) then "mac" else "linux";
  urlFile =
    if (stdenv.isDarwin)
    then "Playback.dmg"
    else if (stdenv.isAarch64)
    then "Playback.arm64.AppImage"
    else "Playback.AppImage";
  sha256 =
    if (stdenv.isDarwin)
    then "sha256-qK1+rLvsrZFZrwyfdtDLqug55jPjle+kvrx+0IxQvNk="
    else if (stdenv.isAarch64)
    then lib.fakeSha256
    else lib.fakeSha256;
  pname = "epilogue-playback";
  src = fetchurl {
    url = "https://epilogue.nyc3.cdn.digitaloceanspaces.com/releases/software/Playback/version/${version}/release/${urlArch}/${urlFile}";
    inherit sha256;
  };
  meta = {
    description = "Play and manage Game Boy cartridges on your computer";
    homepage = "https://www.epilogue.co/";
    license = lib.licenses.unfree;
    platforms = lib.platforms.unix;
  };
in
if (stdenv.isDarwin)
then
  stdenv.mkDerivation
  {
    inherit pname version src meta;

    buildInputs = [ unpackdmg ];
    installPhase = ''
      mkdir -p "$out/Applications"
      cp -R "Playback.app" "$out/Applications/"
    '';
  }
else
  appimageTools.wrapType2 {
    inherit pname version src meta;
  }

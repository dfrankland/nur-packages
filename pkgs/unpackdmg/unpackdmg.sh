#!/bin/bash

# Adapted from
# https://github.com/jacekszymanski/nixcasks/blob/b1dbcbabb04bfb434002eaee687ada37bfab0051/unpackdmg.sh

# from https://discourse.nixos.org/t/help-with-error-only-hfs-file-systems-are-supported-on-ventura/25873/8
echo "File to unpack: $src"
if ! [[ "$src" =~ \.[Dd][Mm][Gg]$ ]]; then exit 1; fi

mnt=$(mktemp -d -t unpackdmg-XXXXXXXXXX)

function finish {
  rm -rf "$mnt"
}
trap finish EXIT

if ! 7zz t "$src" >/dev/null 2>&1; then

  cnv="$mnt/$(basename "$src")"

  # NOTE: will not be needed in next version of 7zip
  # https://sourceforge.net/p/sevenzip/bugs/2411/
  echo "converting $mnt"
  /usr/bin/hdiutil convert -format UDBZ -o "$cnv" "$src"
  src=$cnv

fi

echo "unpacking $src"
7zz -snld x "$src"

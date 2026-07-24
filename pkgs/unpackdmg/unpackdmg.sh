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

# 7zz refuses to extract a "dangerous" symlink whose target is reached through
# another symlink (e.g. chained versioned dylibs), silently ignoring it and
# exiting non-zero. Capture the output so we can recreate those links ourselves.
out="$(7zz -snld x "$src" 2>&1)"
status=$?
printf '%s\n' "$out"

if [ "$status" -ne 0 ]; then
  dangerous=0
  while IFS= read -r line; do
    # Format: ...was ignored : <path> : <target>
    rest="${line#*ignored : }"
    path="${rest% : *}"
    target="${rest##* : }"
    [ -n "$path" ] && [ -n "$target" ] || continue
    echo "recreating dangerous link: $path -> $target"
    rm -f "$path"
    ln -s "$target" "$path"
    dangerous=$((dangerous + 1))
  done < <(printf '%s\n' "$out" | grep -F 'Dangerous link via another link was ignored')

  # Only swallow the failure if every error was a dangerous link we recovered.
  errors="$(printf '%s\n' "$out" | sed -n 's/^Sub items Errors: \([0-9][0-9]*\)$/\1/p' | tail -n 1)"
  if [ "$dangerous" -gt 0 ] && [ "$dangerous" = "${errors:-0}" ]; then
    echo "recreated $dangerous dangerous link(s); treating unpack as successful"
    exit 0
  fi
  exit "$status"
fi

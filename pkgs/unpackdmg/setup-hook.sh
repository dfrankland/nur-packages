#!/bin/bash

unpackCmdHooks+=(_tryUnpackDmg)
_tryUnpackDmg() {
  if ! [[ "$curSrc" =~ \.[Dd][Mm][Gg]$ ]]; then return 1; fi
  unpackdmg "$curSrc"
}

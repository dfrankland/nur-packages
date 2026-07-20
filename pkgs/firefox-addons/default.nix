{pkgs ? import <nixpkgs> {}}: let
  buildMozillaXpiAddon = pkgs.callPackage ./build-mozilla-xpi-addon.nix {};
in
  # Import directly rather than via `callPackage` so the returned attrset stays
  # a plain set of add-on derivations (no injected `override` attribute).
  import ./generated-firefox-addons.nix {
    inherit buildMozillaXpiAddon;
    inherit (pkgs) fetchurl lib stdenv;
  }

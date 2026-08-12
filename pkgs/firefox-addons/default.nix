{pkgs ? import <nixpkgs> {}}: let
  buildMozillaXpiAddon = pkgs.callPackage ./build-mozilla-xpi-addon.nix {};

  # Import directly rather than via `callPackage` so the returned attrset stays
  # a plain set of add-on derivations (no injected `override` attribute).
  generated = import ./generated-firefox-addons.nix {
    inherit buildMozillaXpiAddon;
    inherit (pkgs) fetchurl lib stdenv;
  };

  # Add-ons AMO signs but does not host, which the generator cannot see.
  selfHosted = import ./self-hosted-firefox-addons.nix {
    inherit buildMozillaXpiAddon;
    inherit (pkgs) lib writeScript;
  };
in
  generated // selfHosted

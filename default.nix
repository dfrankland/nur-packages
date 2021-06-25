{ pkgs ? import <nixpkgs> { } }:

{
  lib = import ./lib { inherit pkgs; };
  modules = import ./modules;
  overlays = import ./overlays;

  pritunl-client = pkgs.callPackage ./pkgs/pritunl-client { };
}

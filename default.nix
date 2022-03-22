{ pkgs ? import <nixpkgs> { } }:

{
  lib = import ./lib { inherit pkgs; };
  modules = import ./modules;
  overlays = import ./overlays;

  github-desktop = pkgs.callPackage ./pkgs/github-desktop { };
  trunk = pkgs.callPackage ./pkgs/trunk { };
}

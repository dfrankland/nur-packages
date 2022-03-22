{ pkgs ? import <nixpkgs> { } }:

{
  lib = import ./lib { inherit pkgs; };
  modules = import ./modules;
  overlays = import ./overlays;

  github-desktop = pkgs.callPackage ./pkgs/github-desktop { };
  google-chrome = pkgs.callPackage ./pkgs/google-chrome { };
  qmk_toolbox = pkgs.callPackage ./pkgs/qmk_toolbox { };
  trunk = pkgs.callPackage ./pkgs/trunk { };
}

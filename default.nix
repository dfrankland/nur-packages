{ pkgs ? import <nixpkgs> { } }:

{
  lib = import ./lib { inherit pkgs; };
  modules = import ./modules;
  overlays = import ./overlays;

  github-desktop = pkgs.callPackage ./pkgs/github-desktop { };
  google-chrome = pkgs.callPackage ./pkgs/google-chrome { };
  qmk_toolbox = pkgs.callPackage ./pkgs/qmk_toolbox { };
  rectangle = pkgs.callPackage ./pkgs/rectangle { };
  signal-desktop = pkgs.callPackage ./pkgs/signal-desktop { };
  trunk = pkgs.callPackage ./pkgs/trunk { };
  wavebox = pkgs.callPackage ./pkgs/wavebox { };
  wezterm = pkgs.callPackage ./pkgs/wezterm { };
}

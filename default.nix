{ pkgs ? import <nixpkgs> { } }:

let
  unpackdmg = pkgs.callPackage ./pkgs/unpackdmg { };
in
{
  lib = import ./lib { inherit pkgs; };
  modules = import ./modules;
  overlays = import ./overlays;

  authy = pkgs.callPackage ./pkgs/authy { };
  awscli-local = pkgs.callPackage ./pkgs/awscli-local { };
  cloudflare-ddns = pkgs.callPackage ./pkgs/cloudflare-ddns { };
  docker-desktop = pkgs.callPackage ./pkgs/docker-desktop { };
  gbdk-2020 = pkgs.callPackage ./pkgs/gbdk-2020 { };
  github-desktop = pkgs.callPackage ./pkgs/github-desktop { };
  google-chrome = pkgs.callPackage ./pkgs/google-chrome { };
  lcov = pkgs.callPackage ./pkgs/lcov { };
  qmk_toolbox = pkgs.callPackage ./pkgs/qmk_toolbox { };
  rectangle = pkgs.callPackage ./pkgs/rectangle { };
  rippling = pkgs.callPackage ./pkgs/rippling { };
  signal-desktop = pkgs.callPackage ./pkgs/signal-desktop { };
  tailscale = pkgs.callPackage ./pkgs/tailscale { };
  trunk = pkgs.callPackage ./pkgs/trunk { };
  inherit unpackdmg;
  wavebox = pkgs.callPackage ./pkgs/wavebox { };
  wezterm = pkgs.callPackage ./pkgs/wezterm { };
  zoom-us = pkgs.callPackage ./pkgs/zoom-us { };
}

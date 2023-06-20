{ pkgs ? import <nixpkgs> { } }:

{
  lib = import ./lib { inherit pkgs; };
  modules = import ./modules;
  overlays = import ./overlays;

  authy = pkgs.callPackage ./pkgs/authy { };
  awscli-local = pkgs.callPackage ./pkgs/awscli-local { };
  cloudflare-ddns = pkgs.callPackage ./pkgs/cloudflare-ddns { };
  docker-desktop = pkgs.callPackage ./pkgs/docker-desktop { };
  drata-agent = pkgs.callPackage ./pkgs/drata-agent { };
  github-desktop = pkgs.callPackage ./pkgs/github-desktop { };
  google-chrome = pkgs.callPackage ./pkgs/google-chrome { };
  qmk_toolbox = pkgs.callPackage ./pkgs/qmk_toolbox { };
  rectangle = pkgs.callPackage ./pkgs/rectangle { };
  rippling = pkgs.callPackage ./pkgs/rippling { };
  signal-desktop = pkgs.callPackage ./pkgs/signal-desktop { };
  tailscale = pkgs.callPackage ./pkgs/tailscale { };
  trunk = pkgs.callPackage ./pkgs/trunk { };
  wavebox = pkgs.callPackage ./pkgs/wavebox { };
  wezterm = pkgs.callPackage ./pkgs/wezterm { };
  zigmod = pkgs.callPackage ./pkgs/zigmod { };
  zls = pkgs.callPackage ./pkgs/zls { };
  zoom-us = pkgs.callPackage ./pkgs/zoom-us { };
}

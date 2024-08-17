{ pkgs ? import <nixpkgs> { } }:

let
  unpackdmg = pkgs.callPackage ./pkgs/unpackdmg { };
in
{
  lib = import ./lib { inherit pkgs; };
  modules = import ./modules;
  overlays = import ./overlays;

  awscli-local = pkgs.callPackage ./pkgs/awscli-local { };
  cloudflare-ddns = pkgs.callPackage ./pkgs/cloudflare-ddns { };
  docker-desktop = pkgs.callPackage ./pkgs/docker-desktop { inherit unpackdmg; };
  drata-agent = pkgs.callPackage ./pkgs/drata-agent { inherit unpackdmg; };
  gbdk-2020 = pkgs.callPackage ./pkgs/gbdk-2020 { };
  github-desktop = pkgs.callPackage ./pkgs/github-desktop { };
  google-chrome = pkgs.callPackage ./pkgs/google-chrome { inherit unpackdmg; };
  headscale-ui = pkgs.callPackage ./pkgs/headscale-ui { };
  qmk_toolbox = pkgs.callPackage ./pkgs/qmk_toolbox { };
  rippling = pkgs.callPackage ./pkgs/rippling { };
  signal-desktop = pkgs.callPackage ./pkgs/signal-desktop { };
  trunk = pkgs.callPackage ./pkgs/trunk { };
  inherit unpackdmg;
  wavebox = pkgs.callPackage ./pkgs/wavebox { };
  wifiman-desktop = pkgs.callPackage ./pkgs/wifiman-desktop { };
}

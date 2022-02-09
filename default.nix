{ pkgs ? import <nixpkgs> { } }:

rec {
  lib = import ./lib { inherit pkgs; };
  modules = import ./modules;
  overlays = import ./overlays;

  pritunl-client-service = pkgs.callPackage ./pkgs/pritunl-client-service { };
  pritunl-client = pkgs.callPackage ./pkgs/pritunl-client { pritunl-client-service = pritunl-client-service; };
}

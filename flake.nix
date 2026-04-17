{
  description = "My personal NUR repository";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    zmx.url = "github:neurosnap/zmx";
  };
  outputs = inputs @ {
    flake-parts,
    nixpkgs,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} ({withSystem, ...}: let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];
    in {
      systems = supportedSystems;

      perSystem = {
        self',
        system,
        inputs',
        pkgs,
        packageSet,
        ...
      }: {
        _module.args.pkgs = import nixpkgs {
          inherit system;
          overlays = [
            (final: prev: {
              zmx = inputs.zmx.packages.${system}.default;
            })
          ];
          config.allowUnfree = true;
        };

        packages = import ./default.nix {
          inherit pkgs;
        };

        formatter = pkgs.alejandra;

        checks.alejandra =
          pkgs.runCommand "alejandra" {
            nativeBuildInputs = [pkgs.alejandra];
          } ''
            alejandra --check ${./.}
            touch "$out"
          '';
      };
    });
}

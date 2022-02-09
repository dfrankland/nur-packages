{
  description = "My personal NUR repository";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgsOld.url = "github:NixOS/nixpkgs/nixos-20.09";
  };
  outputs = { self, nixpkgs, nixpkgsOld }:
    let
      # List of systems supported by home-manager binary
      supportedSystems = nixpkgs.lib.platforms.unix;

      # Function to generate a set based on supported systems
      forAllSystems = f:
        nixpkgs.lib.genAttrs supportedSystems (system: f system);
    in
    rec {
      packages = forAllSystems (system:
        import ./default.nix {
          pkgs = import nixpkgsOld {
            inherit system;
            config.allowUnfree = true;
          };
        }
      );

      # overlays = [
      #   (final: prev: {
      #     pritunl-client = packages.x86_64-linux.pritunl-client;
      #   })
      # ];

      nixosModules = import ./modules;
    };
}

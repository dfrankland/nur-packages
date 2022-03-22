{
  description = "My personal NUR repository";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };
  outputs = { self, nixpkgs }:
    let
      # List of systems supported by home-manager binary
      supportedSystems = nixpkgs.lib.platforms.unix;

      # Function to generate a set based on supported systems
      forAllSystems = f:
        nixpkgs.lib.genAttrs supportedSystems (system: f system);
    in
    {
      packages = forAllSystems (system: import ./default.nix {
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
      });
    };
}

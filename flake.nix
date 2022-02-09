{
  description = "My personal NUR repository";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };
  outputs = { self, nixpkgs }:
    let
      # List of systems supported by home-manager binary
      supportedSystems = [
        "x86_64-linux"
        "x86_64-darwin"
      ];

      # Function to generate a set based on supported systems
      forAllSystems = f:
        nixpkgs.lib.genAttrs supportedSystems (system: f system);

      removeSpecialNames = f:
        nixpkgs.lib.filterAttrs (name: value: name != "lib" && name != "modules" && name != "overlays") f;
    in
    {
      packages = forAllSystems (system: removeSpecialNames (import ./default.nix {
        pkgs = import nixpkgs { inherit system; };
      }));

      nixosModules = nixpkgs.lib.mapAttrs (name: value: import value) (import ./modules);
    };
}

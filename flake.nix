{
  description = "My personal NUR repository";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    zig-overlay.url = "github:mitchellh/zig-overlay";
    zig-overlay.inputs.nixpkgs.follows = "nixpkgs";
    known-folders.url = "github:ziglibs/known-folders";
    known-folders.flake = false;
  };
  outputs = { self, nixpkgs, zig-overlay, known-folders }:
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
          overlays = [
            zig-overlay.overlays.default
            (final: prev: {
              inherit known-folders;
            })
          ];
          config.allowUnfree = true;
        };
      });
    };
}

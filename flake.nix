{
  description = "My personal NUR repository";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    zig-overlay.url = "github:mitchellh/zig-overlay";
    zig-overlay.inputs.nixpkgs.follows = "nixpkgs";
    ghostty.url = "github:ghostty-org/ghostty";
    ghostty.inputs.nixpkgs-unstable.follows = "nixpkgs";
    ghostty.inputs.nixpkgs-stable.follows = "nixpkgs";
    ghostty.inputs.zig.follows = "zig-overlay";
  };
  outputs = { nixpkgs, ghostty, ... }:
    let
      # List of systems supported by home-manager binary
      supportedSystems = nixpkgs.lib.platforms.unix;

      # Function to generate a set based on supported systems
      forAllSystems = f:
        nixpkgs.lib.genAttrs supportedSystems (system: f system);
    in
    rec {
      packages = forAllSystems (system: import ./default.nix {
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        ghostty = ghostty.packages.${system}.default;
      });

      # NOTE: Helps verify all packages are buildable.
      # For example, `nix develop` or `nix develop '.#devShell.x86_64-darwin'`
      devShell = forAllSystems (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
        in
        pkgs.mkShell {
          buildInputs = builtins.attrValues (builtins.removeAttrs packages.${system} [ "lib" "modules" "overlays" ]);

          shellHook = ''
            # none
          '';
        });
    };
}

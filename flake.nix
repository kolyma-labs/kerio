{
  description = "Kerio Control VPN flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    # nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    { self
    , nixpkgs
    , flake-utils
    , ...
    } @ inputs:
    let
      lib = nixpkgs.lib;
      systems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];

      forAllSystems = nixpkgs.lib.genAttrs systems;
      forEachSystem = f: lib.genAttrs systems (system: f pkgsFor.${system});

      pkgsFor = lib.genAttrs systems (system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        });

      devShellFor = system:
        let
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
          script = import ./shell.nix { inherit pkgs; };
        in
        script;
    in
    {
      # Nix script formatter
      formatter =
        forAllSystems (system: nixpkgs.legacyPackages.${system}.nixpkgs-fmt);

      # Development environment
      devShells = lib.mapAttrs (system: _: devShellFor system) (lib.genAttrs systems { });

      # Output package
      packages = forAllSystems (system: {
        default = pkgsFor.${system}.callPackage ./. { };
      });
    };
}

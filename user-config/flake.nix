{
  description = "Personal Neovim configuration with Nixvim";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixvim.url = "path:..";
    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default";
  };

  outputs =
    { nixvim, flake-parts, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import inputs.systems;

      perSystem =
        { system, ... }:
        let
          configuration = nixvim.lib.evalNixvim {
            inherit system;
            modules = [ ./config ];
          };
        in
        {
          checks.default = configuration.config.build.test;
          packages.default = configuration.config.build.package;
        };
    };
}

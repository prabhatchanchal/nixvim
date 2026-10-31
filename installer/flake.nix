{
  description = "Nixvim installer build configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixvim.url = "path:../";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    { nixvim, flake-parts, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      perSystem =
        { pkgs, system, ... }:
        let
          configuration = nixvim.lib.nixvim.evalNixvim {
            inherit system;
            modules = [ ./config/nixvim-config.nix ];
          };
        in
        {
          checks.default = configuration.config.build.test;
          packages.default = configuration.config.build.package;
          packages.windowsPayload = pkgs.callPackage ./collect.nix { inherit system; };
        };
    };
}

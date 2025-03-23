{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default";
    flake-compat.url = "github:edolstra/flake-compat";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import inputs.systems;
      imports = [
        inputs.treefmt-nix.flakeModule
      ];

      perSystem =
        { pkgs, lib, ... }:
        {
          treefmt = {
            projectRootFile = "flake.nix";
            programs.nixfmt.enable = true;
            programs.actionlint.enable = true;
          };

          devShells.default = pkgs.mkShell rec {
            nativeBuildInputs = [
              pkgs.nil
              pkgs.sbcl
              pkgs.sbclPackages.qlot-cli
            ];

            buildInputs = [
              pkgs.ncurses
            ];

            ASDF_OUTPUT_TRANSLATIONS = "(:output-translations :inherit-configuration :disable-cache)";
            LD_LIBRARY_PATH = lib.makeLibraryPath buildInputs;

            shellHook = ''
              export PS1="\n[nix-shell\w]$ "
            '';
          };
        };
    };
}

# Multi-machine NixOS configuration for okt's systems
{
  description = "Multi-machine NixOS configuration for okt's systems";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    statusbar = {
      url = "github:oskari-tuormaa/statusbar";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];

      imports =
        let
          # Recursively collect all .nix files under a directory as flake-parts modules
          collectNixFiles =
            dir:
            builtins.concatLists (
              builtins.attrValues (
                builtins.mapAttrs (
                  name: type:
                  let
                    path = dir + "/${name}";
                  in
                  if type == "directory" then
                    collectNixFiles path
                  else if type == "regular" && builtins.match ".*\\.nix$" name != null then
                    [ path ]
                  else
                    [ ]
                ) (builtins.readDir dir)
              )
            );
        in
        collectNixFiles ./modules;
    };
}

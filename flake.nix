{
  description = "Multi-machine NixOS configuration for okt's systems";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, disko, nixos-wsl, ... }@inputs:
    let
      # Import helper functions
      lib = (import ./lib { inherit (nixpkgs) lib; inputs = inputs; });
      
      # System type for our machines
      system = "x86_64-linux";

      # Utility function to create a host with mkHost helper
      mkHost = hostname: modules:
        lib.mkHost {
          inherit hostname system;
          modules = modules;
        };

    in
    {
      nixosConfigurations = {
        # Lovelace: Personal Desktop (NVIDIA GPU + Desktop Environment)
        lovelace = mkHost "lovelace" [
          ./hosts/lovelace
        ];

        # Hopper: Personal Laptop (NVIDIA GPU + Desktop Environment)
        hopper = mkHost "hopper" [
          ./hosts/hopper
        ];

        # Wilson: Work Laptop (Encrypted + Desktop Environment)
        wilson = mkHost "wilson" [
          ./hosts/wilson
        ];

        # Perlman: Home Server (Headless)
        perlman = mkHost "perlman" [
          ./hosts/perlman
        ];

        # Greene: VM Test Host (WSL2 NixOS)
        greene = mkHost "greene" [
          nixos-wsl.nixosModules.default
          ./hosts/greene
        ];
      };

      # Optional: Home Manager configurations for standalone use
      homeConfigurations = {
        "okt@lovelace" = lib.mkHome {
          username = "okt";
          homeDirectory = "/home/okt";
          inherit system;
        };
      };

      # Flake metadata for commands
      apps.${system} = {
        update-flake = {
          type = "app";
          program = "${nixpkgs.legacyPackages.${system}.bash}/bin/bash -c 'nix flake update'";
        };
      };
    };
}

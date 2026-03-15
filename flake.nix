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
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nixos-wsl,
      nix-index-database,
      ...
    }@inputs:
    let
      # Import helper functions
      lib = (
        import ./lib {
          inherit (nixpkgs) lib;
          inputs = inputs;
        }
      );

      # System type for our machines
      system = "x86_64-linux";

      # Utility function to create a host with mkHost helper
      mkHost =
        hostname: modules: extraArgs:
        lib.mkHost (
          {
            inherit hostname system;
            modules = modules;
          }
          // extraArgs
        );

      pkgs = nixpkgs.legacyPackages.${system};

    in
    {
      nixosConfigurations = {
        # Lovelace: Personal Desktop (NVIDIA GPU + Desktop Environment)
        lovelace = mkHost "lovelace" [
          ./hosts/lovelace
        ] { cpuCoreCount = 28; };

        # Hopper: Personal Laptop (NVIDIA GPU + Desktop Environment)
        hopper = mkHost "hopper" [
          ./hosts/hopper
        ] { cpuCoreCount = 8; };

        # Wilson: Work Laptop (Encrypted + Desktop Environment)
        # TODO: Replace with a wilson-specific wallpaper when available
        wilson = mkHost "wilson" [
          ./hosts/wilson
        ] { cpuCoreCount = 8; };

        # Perlman: Home Server (Headless)
        perlman = mkHost "perlman" [
          ./hosts/perlman
        ] { cpuCoreCount = 8; };

        # Greene: VM Test Host (WSL2 NixOS)
        greene = mkHost "greene" [
          nixos-wsl.nixosModules.default
          ./hosts/greene
        ] { cpuCoreCount = 8; };

        # Hedy: QEMU/KVM Test Host (Linux KVM)
        hedy = mkHost "hedy" [
          ./hosts/hedy
        ] { cpuCoreCount = 8; };
      };

      # Development environment
      devShells.${system}.default = pkgs.mkShell {
        description = "Development environment for NixOS configuration";
        buildInputs = with pkgs; [
          nixfmt
          git
          just
        ];
      };
    };
}

# Library helpers exposed as flake.lib — mkHost and mkHome
{ inputs, ... }:

{
  flake.lib = {
    # Create a NixOS host configuration with Home Manager integrated
    # Usage: self.lib.mkHost { hostname; system; modules; cpuCoreCount; wallpaperPath?; }
    mkHost =
      {
        hostname,
        system,
        modules,
        cpuCoreCount,
        wallpaperPath ? ../home/okt/solar.png,
        ...
      }:
      inputs.nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = {
          inherit inputs;
        };

        modules = modules ++ [
          # Ensure home-manager is available
          inputs.home-manager.nixosModules.home-manager

          # nix-index-database: pre-built index for nix-locate and comma
          inputs.nix-index-database.nixosModules.nix-index

          # Add home-manager configuration
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.okt = import ../home/okt;
              extraSpecialArgs = { inherit inputs wallpaperPath cpuCoreCount; };
            };
          }
        ];
      };

    # Create a standalone Home Manager configuration (for non-NixOS use)
    # Usage: self.lib.mkHome { username; system; homeDirectory?; }
    mkHome =
      {
        username,
        homeDirectory ? "/home/${username}",
        system,
        ...
      }:
      inputs.home-manager.lib.homeManagerConfiguration {
        inherit system;
        pkgs = inputs.nixpkgs.legacyPackages.${system};

        modules = [
          ../home/okt
          {
            home = {
              inherit username homeDirectory;
            };
          }
        ];

        extraSpecialArgs = { inherit inputs; };
      };
  };
}

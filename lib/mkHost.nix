# Helper function to create NixOS host configurations
# Usage:
#   lib.mkHost {
#     hostname = "lovelace";
#     system = "x86_64-linux";
#     modules = [ ./modules/common ... ];
#   }

{ inputs, lib }:

{ hostname
, system
, modules
, ...
}@args:

inputs.nixpkgs.lib.nixosSystem {
  inherit system;
  
  specialArgs = {
    inherit inputs;
  };

  modules = modules ++ [
    # Ensure home-manager is available
    inputs.home-manager.nixosModules.home-manager
    
    # Add home-manager configuration
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        users.okt = import ../home/okt;
        extraSpecialArgs = { inherit inputs; };
      };
    }
  ];
}

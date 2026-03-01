# Helper function to create Home Manager configurations (for standalone use)
# Usage:
#   lib.mkHome {
#     username = "okt";
#     homeDirectory = "/home/okt";
#     system = "x86_64-linux";
#   }

{ inputs, lib }:

{
  username,
  homeDirectory ? "/home/${username}",
  system,
  ...
}@args:

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
}

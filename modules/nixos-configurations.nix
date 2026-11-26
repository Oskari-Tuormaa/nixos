{ inputs, self, ... }:
let
  mkHost =
    hostname: system:
    inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        self.modules.nixos."hosts/${hostname}"
        self.modules.nixos.common
      ];
    };
in
{
  flake.nixosConfigurations = {
    lovelace = mkHost "lovelace" "x86_64-linux";
    hamilton = mkHost "hamilton" "x86_64-linux";
  };
}

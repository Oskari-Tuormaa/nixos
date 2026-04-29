# Lovelace: Personal Desktop (NVIDIA GPU + Desktop Environment)
{ self, ... }:

{
  flake.nixosConfigurations.lovelace = self.lib.mkHost {
    hostname = "lovelace";
    system = "x86_64-linux";
    cpuCoreCount = 28;
    modules = [
      self.nixosModules.packages
      self.nixosModules.settings
      self.nixosModules.users
      self.nixosModules.agenix
      self.nixosModules.secureboot
      self.nixosModules.nvidia
      self.nixosModules.desktop
      self.nixosModules."desktop-i3"
      self.nixosModules.bluetooth
      self.nixosModules.steam
      self.nixosModules.stlink
      self.nixosModules."lovelace-hardware"
      {
        networking.hostName = "lovelace";

        # Allow unfree packages (needed for some packages like brave, nvidia drivers)
        nixpkgs.config.allowUnfree = true;

        boot.loader.systemd-boot.enable = true;
        boot.loader.efi.canTouchEfiVariables = true;

        virtualisation.vmVariant = {
          virtualisation = {
            memorySize = 8192;
            cores = 8;
            resolution = {
              x = 1920;
              y = 1080;
            };
          };
        };
      }
    ];
  };
}

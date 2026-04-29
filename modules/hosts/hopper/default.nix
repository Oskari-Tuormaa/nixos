# Hopper: Personal Laptop (NVIDIA GPU + Desktop Environment)
{ self, ... }:

{
  flake.nixosConfigurations.hopper = self.lib.mkHost {
    hostname = "hopper";
    system = "x86_64-linux";
    cpuCoreCount = 8;
    modules = [
      self.nixosModules.packages
      self.nixosModules.settings
      self.nixosModules.users
      self.nixosModules.agenix
      # self.nixosModules.nvidia # TODO: Fix nvidia
      self.nixosModules.desktop
      self.nixosModules."desktop-i3"
      self.nixosModules.bluetooth
      self.nixosModules."hopper-hardware"
      {
        networking.hostName = "hopper";

        # Allow unfree packages (needed for some packages like brave, nvidia drivers)
        nixpkgs.config.allowUnfree = true;

        boot.loader.systemd-boot.enable = true;
        boot.loader.efi.canTouchEfiVariables = true;

        # TODO: Fix DPI scaling in kitty
        services.xserver.dpi = 200;
      }
    ];
  };
}

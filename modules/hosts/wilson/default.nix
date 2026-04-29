# Wilson: Work Laptop (Encrypted + Desktop Environment, Integrated Graphics)
{ self, ... }:

{
  flake.nixosConfigurations.wilson = self.lib.mkHost {
    hostname = "wilson";
    system = "x86_64-linux";
    cpuCoreCount = 8;
    # TODO: Replace with a wilson-specific wallpaper when available
    modules = [
      self.nixosModules.packages
      self.nixosModules.settings
      self.nixosModules.users
      self.nixosModules.agenix
      self.nixosModules.encryption
      self.nixosModules.desktop
      self.nixosModules."desktop-i3"
      self.nixosModules.stlink
      self.nixosModules."wilson-hardware"
      {
        networking.hostName = "wilson";

        # Allow unfree packages (needed for some packages like brave)
        nixpkgs.config.allowUnfree = true;

        boot.loader.systemd-boot.enable = true;
        boot.loader.efi.canTouchEfiVariables = true;
      }
    ];
  };
}

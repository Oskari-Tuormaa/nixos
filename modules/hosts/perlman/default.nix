# Perlman: Home Server (Headless, T480 laptop as server)
{ self, ... }:

{
  flake.nixosConfigurations.perlman = self.lib.mkHost {
    hostname = "perlman";
    system = "x86_64-linux";
    cpuCoreCount = 8;
    modules = [
      self.nixosModules.packages
      self.nixosModules.settings
      self.nixosModules.users
      self.nixosModules.agenix
      self.nixosModules.services
      self.nixosModules."perlman-hardware"
      {
        networking.hostName = "perlman";

        # Allow unfree packages (needed for some packages like brave)
        nixpkgs.config.allowUnfree = true;

        # Disable X11 for headless server
        services.xserver.enable = false;

        # Enable SSH for remote access
        services.openssh = {
          enable = true;
          settings.PasswordAuthentication = true;
        };
      }
    ];
  };
}

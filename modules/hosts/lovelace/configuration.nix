{ self, inputs, ... }:
{
  flake.nixosConfigurations.lovelace = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.common
      self.nixosModules.lovelace
    ];
  };

  flake.nixosModules.lovelace =
    { ... }:
    {
      imports = [
        self.nixosModules.desktop
      ];

      networking.hostName = "lovelace";

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

      # Allow unfree packages (needed for some packages like brave, nvidia drivers)
      nixpkgs.config.allowUnfree = true;

      # Desktop-specific services can go here
      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;
    };
}

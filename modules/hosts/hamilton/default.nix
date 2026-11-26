{ self, ... }: {
  flake.modules.nixos."hosts/hamilton" = { ... }: {
    imports = [
      ./_hardware-configuration.nix

      self.modules.nixos.desktop-cosmic
      self.modules.nixos.steam
      self.modules.nixos.packet
      self.modules.nixos.fingerprint
    ];

    hardware.bluetooth.enable = true;

    virtualisation.vmVariant = {
      virtualisation = {
        memorySize = 8192;
        cores = 12;
        resolution = {
          x = 2880;
          y = 1920;
        };
      };
    };

    networking.hostName = "hamilton";
    networking.enableIPv6 = false;

    # Allow unfree packages (needed for some packages like brave, nvidia drivers)
    nixpkgs.config.allowUnfree = true;

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
  };
}

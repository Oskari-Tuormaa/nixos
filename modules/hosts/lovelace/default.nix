{ self, ... }: {
  flake.modules.nixos."hosts/lovelace" = { ... }: {
    imports = [
      ./_hardware-configuration.nix

      self.modules.nixos.desktop-cosmic
      self.modules.nixos.nvidia
      self.modules.nixos.stlink
      self.modules.nixos.noisetorch
      self.modules.nixos.docker
      self.modules.nixos.steam
      self.modules.nixos.packet
    ];

    hardware.bluetooth.enable = true;

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

    networking.hostName = "lovelace";
    networking.enableIPv6 = false;

    # Allow unfree packages (needed for some packages like brave, nvidia drivers)
    nixpkgs.config.allowUnfree = true;

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
  };
}

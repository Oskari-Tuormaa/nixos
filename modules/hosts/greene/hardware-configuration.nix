# Greene (WSL2) hardware configuration
# To regenerate after installing NixOS-WSL:
# 1. Inside Greene WSL: sudo nixos-generate-config --root /
# 2. Copy output to this file
_: {
  flake.nixosModules."greene-hardware" =
    { modulesPath, ... }:
    {
      imports = [
        (modulesPath + "/profiles/minimal.nix")
      ];

      # WSL virtualisation
      boot.isContainer = true;
      boot.loader.grub.enable = false;
      boot.loader.systemd-boot.enable = false;

      # Filesystems
      fileSystems."/" = {
        device = "/dev/disk/by-uuid/00000000-0000-0000-0000-000000000000";
        fsType = "ext4";
      };

      # Don't require a password for sudo in WSL
      security.sudo.wheelNeedsPassword = false;
    };
}

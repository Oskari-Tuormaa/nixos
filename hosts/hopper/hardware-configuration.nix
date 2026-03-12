# Hopper hardware configuration
# Generate with: nixos-generate-config --root /mnt
# This is a placeholder - will be replaced when you install NixOS on hopper

{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  # Minimal placeholder filesystem configuration
  fileSystems."/" = {
    device = "/dev/null";
    fsType = "tmpfs";
  };

  boot.loader.grub.devices = [ "/dev/sda" ];

  # TODO: Replace with actual hardware-configuration.nix after running nixos-generate-config
}

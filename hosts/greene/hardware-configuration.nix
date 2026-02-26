# Greene (WSL2) hardware configuration
# Generated from NixOS-WSL environment
# 
# To regenerate this file after installing NixOS-WSL:
# 1. Inside Greene WSL: sudo nixos-generate-config --root /
# 2. Copy output to this file
# 
# For initial setup, this minimal config will work with NixOS-WSL defaults

{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/profiles/minimal.nix")
  ];

  # WSL virtualization
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

  # Locale
  time.timeZone = "UTC";
  i18n.defaultLocale = "en_US.UTF-8";

  # After installing, replace the above with actual output from:
  # sudo nixos-generate-config --root / > /tmp/hw.nix
}

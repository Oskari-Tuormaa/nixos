{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/common
    ../../modules/features/encryption.nix
    ../../modules/features/desktop.nix
  ];

  networking.hostName = "qemu";

  # Allow unfree packages (needed for some packages like brave)
  nixpkgs.config.allowUnfree = true;

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";
  boot.loader.grub.useOSProber = true;
}

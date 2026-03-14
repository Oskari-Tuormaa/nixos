# Wilson: Work Laptop (Encrypted + Desktop Environment, Integrated Graphics)
{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/common
    ../../modules/features/encryption.nix
    ../../modules/features/desktop.nix
    ../../modules/features/desktop-i3.nix
    ../../modules/features/stlink.nix
  ];

  networking.hostName = "wilson";

  # Allow unfree packages (needed for some packages like brave)
  nixpkgs.config.allowUnfree = true;

  # Work laptop-specific configuration can go here
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
}

# Hopper: Personal Laptop (NVIDIA GPU + Desktop Environment)
{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/common
    # ../../modules/features/nvidia.nix # TODO: Fix nvidia
    ../../modules/features/desktop.nix
    ../../modules/features/desktop-i3.nix
  ];

  networking.hostName = "hopper";

  # Allow unfree packages (needed for some packages like brave, nvidia drivers)
  nixpkgs.config.allowUnfree = true;

  # Laptop-specific optimizations can go here
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services.xserver.dpi = 200;

  # TODO: Fix DPI scaling in kitty
}

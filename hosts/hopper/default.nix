# Hopper: Personal Laptop (NVIDIA GPU + Desktop Environment)
{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/common
    ../../modules/features/nvidia
    ../../modules/features/desktop
  ];

  networking.hostName = "hopper";

  # Allow unfree packages (needed for some packages like brave, nvidia drivers)
  nixpkgs.config.allowUnfree = true;

  # Laptop-specific optimizations can go here
}

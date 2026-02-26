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

  # Laptop-specific optimizations can go here
}

# Lovelace: Personal Desktop (NVIDIA GPU + Desktop Environment)
{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/common
    ../../modules/features/nvidia
    ../../modules/features/desktop
  ];

  networking.hostName = "lovelace";

  # Allow unfree packages (needed for some packages like brave, nvidia drivers)
  nixpkgs.config.allowUnfree = true;

  # Desktop-specific services can go here
}

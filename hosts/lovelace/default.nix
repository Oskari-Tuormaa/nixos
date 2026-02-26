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

  # Desktop-specific services can go here
}

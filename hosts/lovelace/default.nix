# Lovelace: Personal Desktop (NVIDIA GPU + Desktop Environment)
{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/common
    ../../modules/features/secureboot.nix
    ../../modules/features/nvidia.nix
    ../../modules/features/minecraft.nix
    ../../modules/features/desktop.nix
    ../../modules/features/desktop-cosmic.nix
    ../../modules/features/steam.nix
    ../../modules/features/stlink.nix
    ../../modules/features/noisetorch.nix
    ../../modules/features/docker.nix
    ../../modules/features/bitwig_studio.nix
  ];

  hardware.bluetooth.enable = true;

  virtualisation.vmVariant = {
    virtualisation = {
      memorySize = 8192;
      cores = 8;
      resolution = {
        x = 1920;
        y = 1080;
      };
    };
  };

  networking.hostName = "lovelace";
  networking.enableIPv6 = false;

  # Allow unfree packages (needed for some packages like brave, nvidia drivers)
  nixpkgs.config.allowUnfree = true;

  # Desktop-specific services can go here
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
}

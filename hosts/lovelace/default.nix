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
    ../../modules/features/desktop-i3.nix
    ../../modules/features/bluetooth.nix
    ../../modules/features/steam.nix
    ../../modules/features/stlink.nix
    ../../modules/features/noisetorch.nix
    ../../modules/features/docker.nix
  ];

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

  # Always use performance mode on desktop
  services.auto-cpufreq.settings = {
    charger = {
      governor = "performance";
      turbo = "auto";
    };
  };

  # Desktop-specific services can go here
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
}

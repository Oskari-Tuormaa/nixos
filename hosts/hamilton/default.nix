# Hamilton: Framework Laptop (Desktop Environment)
{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/common
    ../../modules/features/desktop.nix
    ../../modules/features/desktop-i3.nix
    ../../modules/features/bluetooth.nix
  ];

  virtualisation.vmVariant = {
    virtualisation = {
      memorySize = 8192;
      cores = 12;
      resolution = {
        x = 1920;
        y = 1080;
      };
    };
  };

  networking.hostName = "hamilton";
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

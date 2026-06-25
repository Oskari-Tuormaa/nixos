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

  # Laptop: Switch between battery and charger profiles for power efficiency
  services.auto-cpufreq.settings = {
    battery = {
      governor = "powersave";
      turbo = "never";
    };
    charger = {
      governor = "performance";
      turbo = "auto";
    };
  };

  # Work laptop-specific configuration can go here
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
}

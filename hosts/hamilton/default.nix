# Hamilton: Framework Laptop (Desktop Environment)
{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/common
    ../../modules/features/desktop.nix
    ../../modules/features/desktop-cosmic.nix
    ../../modules/features/bitwig_studio.nix
  ];

  hardware.bluetooth.enable = true;

  virtualisation.vmVariant = {
    virtualisation = {
      memorySize = 8192;
      cores = 12;
      resolution = {
        x = 2880;
        y = 1920;
      };
    };
  };

  networking.hostName = "hamilton";
  networking.enableIPv6 = false;

  # Allow unfree packages (needed for some packages like brave, nvidia drivers)
  nixpkgs.config.allowUnfree = true;

  # Desktop-specific services can go here
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Environment variables for Qt/Wayland scaling and cursor
  # Wayland uses cursor size without DPI multiplication
  # environment.variables = {
  #   QT_AUTO_SCREEN_SCALE_FACTOR = "1";
  #   QT_SCALE_FACTOR = "1.5";
  #   GDK_SCALE = "1.5";
  #   XCURSOR_SIZE = "32";
  #   STEAM_FORCE_DESKTOPUI_SCALING = "1.5";
  # };
}

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
        x = 2880;
        y = 1920;
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

  # HiDPI scaling (2880x1920 @ ~290 PPI)
  # 144 DPI = 150% scaling (integer multiple of 96 for best rendering)
  services.xserver.dpi = 144;
  services.xserver.upscaleDefaultCursor = true;

  # Environment variables for Qt/Steam scaling
  # NOTE: GDK_SCALE is NOT set because services.xserver.dpi=144 already provides 1.5x scaling via Xft.dpi
  # Using both would cause double-scaling in GTK apps
  environment.variables = {
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    QT_SCALE_FACTOR = "1.5";
    XCURSOR_SIZE = "64";
    STEAM_FORCE_DESKTOPUI_SCALING = "1.5";
  };

  # Expose variables to graphical systemd user services
  services.xserver.displayManager.importedVariables = [
    "QT_AUTO_SCREEN_SCALE_FACTOR"
    "QT_SCALE_FACTOR"
    "XCURSOR_SIZE"
    "STEAM_FORCE_DESKTOPUI_SCALING"
  ];
}

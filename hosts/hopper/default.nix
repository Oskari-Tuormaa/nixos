# Hopper: Personal Laptop (NVIDIA GPU + Desktop Environment)
{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/common
    ../../modules/features/nvidia-hybrid.nix
    ../../modules/features/steam.nix
    ../../modules/features/desktop.nix
    ../../modules/features/bluetooth.nix
    ../../modules/features/desktop-i3.nix
    ../../modules/features/noisetorch.nix
    ../../modules/services/default.nix
  ];

  networking.hostName = "hopper";

  # Allow unfree packages (needed for some packages like brave, nvidia drivers)
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

  # Laptop-specific optimizations can go here
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # HiDPI scaling (3840x2400 @ ~290 PPI)
  # 192 DPI = 200% scaling (integer multiple of 96 for best rendering)
  services.xserver.dpi = 192;
  services.xserver.upscaleDefaultCursor = true;

  # Environment variables for Qt/Steam scaling
  # NOTE: GDK_SCALE is NOT set because services.xserver.dpi=192 already provides 2x scaling via Xft.dpi
  # Using both would cause double-scaling in GTK apps (4x total)
  environment.variables = {
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    QT_SCALE_FACTOR = "2";
    XCURSOR_SIZE = "64";
    STEAM_FORCE_DESKTOPUI_SCALING = "2";
  };

  # Expose variables to graphical systemd user services
  services.xserver.displayManager.importedVariables = [
    "QT_AUTO_SCREEN_SCALE_FACTOR"
    "QT_SCALE_FACTOR"
    "XCURSOR_SIZE"
    "STEAM_FORCE_DESKTOPUI_SCALING"
  ];
}

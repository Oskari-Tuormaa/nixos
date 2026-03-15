# Common desktop environment configuration for lovelace, hopper, wilson, greene
{ config, pkgs, ... }:

{
  services.displayManager.ly.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  # udisks2 is the D-Bus backend required by udiskie (managed as a user service via Home Manager)
  services.udisks2.enable = true;

  environment.systemPackages = with pkgs; [
    # Screenshots
    flameshot

    # Application runner
    rofi

    # Terminal
    kitty

    # File browser
    nemo

    # PDF Reader
    zathura

    # Audio control interface
    pavucontrol

    # Assorted GUI programs
    spotify
    discord
    teams-for-linux

    # Misc
    feh
  ];
}

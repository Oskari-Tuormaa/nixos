# Desktop environment (X11, i3, picom) for lovelace, hopper, wilson, greene
{ config, pkgs, ... }:

{
  services.xserver = {
    enable = true;
    windowManager.i3.enable = true;
    autoRepeatDelay = 250;
    autoRepeatInterval = 25;
    xkb = {
      layout = "us,dk";
      options = "grp:alt_space_toggle,caps:swapescape";
    };
  };

  services.displayManager.ly.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  # udisks2 is the D-Bus backend required by udiskie (managed as a user service via Home Manager)
  services.udisks2.enable = true;

  environment.systemPackages = with pkgs; [
    # Window manager
    i3
    i3status
    picom
    rofi

    # Screenshots
    flameshot

    # Terminal
    kitty

    # File browser
    nemo

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

# Desktop environment (X11, i3, picom) for lovelace, hopper, wilson, greene
{ config, pkgs, ... }:

{
  services.xserver = {
    enable = true;
    displayManager.lightdm.enable = true;
    windowManager.i3.enable = true;
    autoRepeatDelay = 250;
    autoRepeatInterval = 25;
    xkb = {
      layout = "us,dk";
      options = "grp:alt_space_toggle,caps:swapescape";
    };
  };

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

    # Browser
    brave
  ];
}

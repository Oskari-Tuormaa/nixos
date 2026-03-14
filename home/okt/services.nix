# User services for 'okt'
{
  config,
  osConfig,
  pkgs,
  lib,
  ...
}:

{
  # Picom compositor - shadows enabled, no blur, no animations
  # Only enable on systems with X11
  services.picom = lib.mkIf osConfig.services.xserver.enable {
    enable = true;
    vSync = true;
    shadow = true;
    shadowOffsets = [
      (-18)
      (-18)
    ];
    shadowOpacity = 0.6;
    fade = false;
    settings = {
      shadow-radius = 18;
      # Avoid shadows on i3 bar and desktop elements
      shadow-exclude = [
        "name = 'i3bar'"
        "class_g = 'i3bar'"
        "_NET_WM_STATE@:32a *= '_NET_WM_STATE_HIDDEN'"
      ];
    };
  };

  # Dunst notification daemon - only on X11 systems
  services.dunst.enable = osConfig.services.xserver.enable;

  # Udiskie USB automounting - works on any system
  services.udiskie.enable = true;

  # Redshift - adjust color temperature based on time of day
  # Only enable on systems with X11
  services.redshift = lib.mkIf osConfig.services.xserver.enable {
    enable = true;
    # Use geolocation with fallback to manual coordinates
    provider = "geoclue2";
    latitude = 56.1629;
    longitude = 10.2039;
    # Color temperatures
    temperature.day = 6500;
    temperature.night = 2400;
  };
}

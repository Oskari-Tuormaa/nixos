# User services for 'okt'
{ config, pkgs, ... }:

{
  # Picom compositor - shadows enabled, no blur, no animations
  services.picom = {
    enable = true;
    shadow = true;
    shadowOffsets = [ (-7) (-7) ];
    shadowOpacity = 0.75;
    fade = false;
    settings = {
      # Avoid shadows on i3 bar and desktop elements
      shadow-exclude = [
        "name = 'i3bar'"
        "class_g = 'i3bar'"
        "_NET_WM_STATE@:32a *= '_NET_WM_STATE_HIDDEN'"
      ];
    };
  };
}

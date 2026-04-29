# Desktop configuration for wayland/hyprland
_: {
  flake.nixosModules."desktop-hyprland" =
    { ... }:
    {
      programs.hyprland = {
        enable = true;
      };
    };
}

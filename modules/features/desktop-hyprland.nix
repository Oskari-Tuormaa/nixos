# Desktop configuration for wayland/hyprland
{ config, pkgs, ... }:
{
  services.displayManager.ly.enable = true;

  programs.hyprland = {
    enable = true;
  };
}

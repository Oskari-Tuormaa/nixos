# Home Manager configuration for user 'okt'
# This configuration is shared across all machines
{
  config,
  osConfig,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ./programs.nix
    ./services.nix
    ./ssh.nix
    ./steam.nix
  ]
  ++ lib.optionals osConfig.services.xserver.enable [
    # Import xserver stuff
    ./i3.nix
    ./rofi.nix
  ]
  ++ lib.optionals osConfig.programs.hyprland.enable [
    # Import wayland stuff
    ./hyprland.nix
    ./rofi.nix
  ];

  # Home Manager configuration
  home.username = "okt";
  home.homeDirectory = "/home/okt";
  home.stateVersion = "24.05";

  # Note: nixpkgs.config should be set at the system level when using
  # home-manager.useGlobalPkgs = true (which we do in NixOS configs)

  # Environment variables
  home.sessionVariables = {
    EDITOR = "nvim";
    TERMINAL = "kitty";
  };

  # Set fish as the default shell (managed by home-manager)
  home.preferXdgDirectories = true;

  # Fonts
  home.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  # Let home-manager manage itself
  programs.home-manager.enable = true;
}

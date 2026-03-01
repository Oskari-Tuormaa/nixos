# Home Manager configuration for user 'okt'
# This configuration is shared across all machines
{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ./programs.nix
    ./services.nix
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

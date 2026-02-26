# Home Manager configuration for user 'okt'
# This configuration is shared across all machines
{ config, pkgs, lib, ... }:

{
  imports = [
    ./programs.nix
    ./services.nix
  ];

  # Home Manager configuration
  home.username = "okt";
  home.homeDirectory = "/home/okt";
  home.stateVersion = "24.05";

  # Allow unfree packages if needed
  nixpkgs.config.allowUnfree = true;

  # Environment variables
  home.sessionVariables = {
    EDITOR = "nvim";
    TERMINAL = "kitty";
  };

  # Let home-manager manage itself
  programs.home-manager.enable = true;
}

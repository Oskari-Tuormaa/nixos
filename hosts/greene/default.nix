# Greene: WSL2 NixOS Test Host (Headless)
# A safe sandbox for learning NixOS, testing the flake, and development work
# Before using this, install NixOS-WSL manually:
# 1. Download nixos-wsl.tar.gz from https://github.com/nix-community/NixOS-WSL/releases
# 2. From PowerShell: wsl --import greene . C:\path\to\nixos-wsl.tar.gz --version 2
# 3. Deploy: sudo nixos-rebuild switch --flake .#greene

{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/common
  ];

  networking.hostName = "greene";

  # Allow unfree packages (needed for some packages like brave)
  nixpkgs.config.allowUnfree = true;

  # WSL-specific configuration
  # The nixos-wsl module is added in flake.nix and provides defaults
  # These settings override/customize the module behavior
  wsl = {
    enable = true;
    defaultUser = "okt";
    # Note: nativeSystemd is now always enabled by default in nixos-wsl
  };

  # Home Manager integration - same as other machines
  home-manager.users.okt = import ../../home/okt;

  # Disable graphics since this is headless
  services.xserver.enable = false;

  # Enable SSH for remote access if needed
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = true;
  };

  # System state version
  system.stateVersion = "24.05";
}

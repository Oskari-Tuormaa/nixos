# Perlman: Home Server (Headless, T480 laptop as server)
{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/common
    ../../modules/services
  ];

  networking.hostName = "perlman";

  # Allow unfree packages (needed for some packages like brave)
  nixpkgs.config.allowUnfree = true;

  # Disable X11 for headless server
  services.xserver.enable = false;

  # Enable SSH for remote access
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = true;
  };

  # Server-specific configuration can go here
}

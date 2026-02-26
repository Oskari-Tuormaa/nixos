# VirtualBox guest support for greene (VM test host)
{ config, pkgs, ... }:

{
  virtualisation.virtualbox.guest.enable = true;

  environment.systemPackages = with pkgs; [
    virtualbox-guest-additions
  ];

  # Enable clipboard sharing with host
  virtualisation.virtualbox.guest.clipboard = true;
}

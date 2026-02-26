# User configuration common to all machines
{ config, pkgs, ... }:

{
  # Create the okt user
  users.users.okt = {
    isNormalUser = true;
    home = "/home/okt";
    extraGroups = [ "wheel" ];  # Allow sudo
    # Shell is managed by home-manager, not set here
  };
}

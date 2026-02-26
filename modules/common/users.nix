# User configuration common to all machines
{ config, pkgs, ... }:

{
  # Create the okt user with fish as default shell
  users.users.okt = {
    isNormalUser = true;
    home = "/home/okt";
    shell = pkgs.fish;
    extraGroups = [ "wheel" ];  # Allow sudo
  };
}

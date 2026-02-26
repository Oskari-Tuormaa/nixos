# User configuration common to all machines
{ config, pkgs, ... }:

{
  # Create the okt user with fish as default shell
  users.users.okt = {
    isNormalUser = true;
    home = "/home/okt";
    shell = pkgs.fish;  # Set fish as default shell
    extraGroups = [ "wheel" ];  # Allow sudo
  };
  
  # Suppress the shell program check warning since we're setting fish
  # in both system and home-manager configs (which is safe)
  users.users.okt.ignoreShellProgramCheck = true;
}

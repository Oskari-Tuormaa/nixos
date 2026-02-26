# Wilson: Work Laptop (Encrypted + Desktop Environment, Integrated Graphics)
{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/common
    ../../modules/features/encryption
    ../../modules/features/desktop
  ];

  networking.hostName = "wilson";

  # Allow unfree packages (needed for some packages like brave)
  nixpkgs.config.allowUnfree = true;

  # Work laptop-specific configuration can go here
}

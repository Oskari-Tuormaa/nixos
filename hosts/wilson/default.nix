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

  # Work laptop-specific configuration can go here
}

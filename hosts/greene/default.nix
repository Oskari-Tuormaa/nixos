# Greene: VM Test Host (VirtualBox VM with Desktop Environment)
{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/common
    ../../modules/features/desktop
    ../../modules/features/vm-guest
  ];

  networking.hostName = "greene";

  # VM-specific optimizations can go here
}

# NVIDIA GPU support for desktop machines (lovelace)
{ config, pkgs, ... }:

{
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = true;
    # Force full composition pipeline for tear-free rendering on desktop
    forceFullCompositionPipeline = true;
  };

  environment.systemPackages = with pkgs; [
    # cuda
  ];
}

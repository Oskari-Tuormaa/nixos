# NVIDIA GPU support for laptops with hybrid graphics (Intel iGPU + NVIDIA dGPU)
# Enables PRIME offload mode: Intel GPU for display (battery efficient),
# NVIDIA GPU available via 'prime-run' for demanding tasks
# Usage: prime-run steam, prime-run blender, etc.
{ config, pkgs, ... }:

{
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = true;
    # PRIME offload mode: render on Intel, offload to NVIDIA on demand
    prime = {
      offload.enable = true;
      # Bus IDs for PRIME coordination (Intel iGPU + NVIDIA dGPU)
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

}

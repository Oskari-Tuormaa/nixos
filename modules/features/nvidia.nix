# NVIDIA GPU support for desktop machines (lovelace)
{ ... }: {
  flake.modules.nixos.nvidia =
    { ... }:
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

      hardware.graphics = {
        enable = true;
        enable32Bit = true;
      };
    };
}

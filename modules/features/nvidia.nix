# NVIDIA GPU support for lovelace and hopper
_: {
  flake.nixosModules.nvidia =
    { ... }:
    {
      services.xserver.videoDrivers = [ "nvidia" ];

      hardware.nvidia = {
        modesetting.enable = true;
        powerManagement.enable = false;
        powerManagement.finegrained = false;
        open = true;
        # Force full composition pipeline for tear-free rendering
        forceFullCompositionPipeline = true;
      };
    };
}

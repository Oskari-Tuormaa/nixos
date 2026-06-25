# NoiseTorch: Real-time microphone noise suppression via RNNoise
{ config, pkgs, ... }:
{
  # Enable NoiseTorch with proper Linux capabilities handling
  # The module automatically wraps the binary with CAP_SYS_RESOURCE capability
  programs.noisetorch.enable = true;
}

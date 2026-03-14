# Steam configuration for user 'okt'
# Configures shader compilation threading based on system CPU core count
{
  osConfig,
  cpuCoreCount,
  lib,
  ...
}:

lib.mkIf osConfig.programs.steam.enable {
  home.file.".steam/steam/steam_dev.cfg".text = ''
    unShaderBackgroundProcessingThreads ${builtins.toString cpuCoreCount}
  '';
}

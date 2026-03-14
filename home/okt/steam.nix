# Steam configuration for user 'okt'
# Configures shader compilation threading based on system CPU core count
{ cpuCoreCount, ... }:

{
  xdg.configFile."Steam/steam_dev.cfg".text = ''
    unShaderBackgroundProcessingThreads ${builtins.toString cpuCoreCount}
  '';
}

# NoiseTorch Home Manager configuration with auto-start and declarative settings
{
  config,
  lib,
  pkgs,
  ...
}:
{
  home.packages = [ pkgs.noisetorch ];

  # Declarative NoiseTorch configuration
  xdg.configFile."noisetorch/config.toml".source = (pkgs.formats.toml { }).generate "config.toml" {
    Threshold = 50;
    FilterInput = true;
    FilterOutput = false;
    EnableUpdates = false;
    DisplayMonitorSources = false;
  };

  # Workaround for PipeWire 1.6.3+ LADSPA plugin loading issues with NoiseTorch
  # NoiseTorch creates temporary LADSPA plugin in /tmp but PipeWire restricts search paths
  home.sessionVariables = {
    LADSPA_PATH = "/tmp:/usr/lib/ladspa:/usr/lib64/ladspa";
  };

  # Auto-start NoiseTorch on graphical session start via desktop autostart
  # (systemd user services don't have proper PipeWire socket access)
  xdg.configFile."autostart/noisetorch.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=NoiseTorch
    Comment=Real-time microphone noise suppression
    Exec=/run/wrappers/bin/noisetorch -i -s alsa_input.usb-VNV_Streaming_Webcam-02.analog-stereo
    NoDisplay=true
    Categories=Audio;
  '';
}

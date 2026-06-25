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

  # Auto-start NoiseTorch on graphical session start
  systemd.user.services.noisetorch = {
    Unit = {
      Description = "NoiseTorch microphone noise suppression";
      PartOf = "graphical-session.target";
      After = [
        "pipewire.service"
        "pipewire-pulse.service"
      ];
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.noisetorch} -i -log";
      RemainAfterExit = true;
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}

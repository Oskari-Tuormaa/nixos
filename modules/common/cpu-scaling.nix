# CPU frequency scaling configuration for better performance and power management
{ config, lib, ... }:
{
  # Enable auto-cpufreq for automatic AC/battery switching
  services.auto-cpufreq.enable = true;

  # Default fallback settings (can be overridden per-host)
  services.auto-cpufreq.settings = lib.mkDefault {
    charger = {
      governor = "performance";
      turbo = "auto";
    };
    battery = {
      governor = "powersave";
      turbo = "never";
    };
  };

  # Enable thermald for proactive thermal management (Intel CPUs)
  # This prevents throttling by managing temps before reaching critical limits
  services.thermald.enable = true;

  # Boot parameters to enable intel_pstate with HWP
  boot.kernelParams = [ "intel_pstate=active" ];

  # Security settings for CPU governor changes
  security.polkit.enable = true;

  # Allow members of the gamemode group to change CPU governor without root password
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if ((action.id == "org.freedesktop.login1.power-off" ||
           action.id == "org.freedesktop.login1.power-off-multiple-sessions" ||
           action.id == "org.freedesktop.login1.reboot" ||
           action.id == "org.freedesktop.login1.reboot-multiple-sessions") &&
          subject.isInGroup("gamemode")) {
        return polkit.Result.YES;
      }
    });

    // Allow gamemode to change CPU frequency scaling governor
    polkit.addRule(function(action, subject) {
      if (action.id.indexOf("org.gnome.cpufrequtils") == 0 &&
          subject.isInGroup("gamemode")) {
        return polkit.Result.YES;
      }
    });
  '';

  # Ensure gamemode user/group exists and is configured
  users.groups.gamemode = { };
}

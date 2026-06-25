# CPU frequency scaling configuration for better performance and power management
{ config, lib, ... }:
{
  # Intel P-State driver configuration
  # Hardware P-State (HWP) support for modern Intel CPUs
  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";

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

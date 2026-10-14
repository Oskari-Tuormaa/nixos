{ config, pkgs, ... }:
{
  services = {
    displayManager.cosmic-greeter.enable = true;
    system76-scheduler.enable = true;
    desktopManager.cosmic.enable = true;
  };
}

# Common system settings for all machines
{ config, pkgs, lib, ... }:

{
  # Locale and timezone - customize as needed
  time.timeZone = "UTC";
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable networking by default
  networking.useDHCP = lib.mkDefault true;

  # Basic system configuration
  system.stateVersion = "24.05";
}

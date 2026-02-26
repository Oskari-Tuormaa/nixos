# Common system settings for all machines
{ config, pkgs, lib, ... }:

{
  # Locale and timezone - customize as needed
  time.timeZone = "UTC";
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable networking by default
  networking.useDHCP = lib.mkDefault true;

  # Enable Nix flakes and nix-command
  nix = {
    settings.experimental-features = [ "nix-command" "flakes" ];
  };

  # Basic system configuration
  system.stateVersion = "24.05";
}

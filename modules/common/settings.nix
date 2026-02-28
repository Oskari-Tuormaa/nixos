# Common system settings for all machines
{ config, pkgs, lib, ... }:

{
  # Locale and timezone - customize as needed
  time.timeZone = "Europe/Copenhagen";
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable networking by default
  networking.useDHCP = lib.mkDefault true;
  networking.networkmanager.enable = true;

  # Enable Nix flakes and nix-command
  nix = {
    settings.experimental-features = [ "nix-command" "flakes" ];
  };

  # Swap caps lock and escape keys
  services.xserver.xkb.options = "caps:swapescape";

  # Basic system configuration
  system.stateVersion = "24.05";
}

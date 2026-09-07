# Common system settings for all machines
{
  lib,
  ...
}:

{
  # Locale and timezone - customize as needed
  time.timeZone = "Europe/Copenhagen";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "da_DK.UTF-8";
    LC_IDENTIFICATION = "da_DK.UTF-8";
    LC_MEASUREMENT = "da_DK.UTF-8";
    LC_MONETARY = "da_DK.UTF-8";
    LC_NAME = "da_DK.UTF-8";
    LC_NUMERIC = "da_DK.UTF-8";
    LC_PAPER = "da_DK.UTF-8";
    LC_TELEPHONE = "da_DK.UTF-8";
    LC_TIME = "da_DK.UTF-8";
  };

  # Enable networking by default
  networking.useDHCP = lib.mkDefault true;
  networking.networkmanager.enable = true;

  nix.settings = {
    # Enable Nix flakes and nix-command
    experimental-features = [
      "nix-command"
      "flakes"
    ];

    substituters = [
      "https://nix-community.cachix.org"
    ];

    trusted-public-keys = [
      "hydra.nixos.org-1:CNHJZBh9K4tP3EKF6FkkgeVYsS3ohTl+oS0Qa8bezVs="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  # Enable nix-ld globally
  programs.nix-ld.enable = true;

  # Basic system configuration
  system.stateVersion = "24.05";
}

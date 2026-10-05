# Home Manager configuration for user 'okt'
# This configuration is shared across all machines
{
  config,
  osConfig,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ./programs.nix
    ./secrets.nix
    ./services.nix
    ./ssh.nix
    ./steam.nix
  ]
  ++ lib.optionals osConfig.services.xserver.enable [
    # Import xserver stuff
    ./i3.nix
    ./rofi.nix
    ./noisetorch.nix
  ]
  ++ lib.optionals osConfig.programs.hyprland.enable [
    # Import wayland stuff
    ./hyprland.nix
    ./rofi.nix
    ./noisetorch.nix
  ];

  # Home Manager configuration
  home.username = "okt";
  home.homeDirectory = "/home/okt";
  home.stateVersion = "24.05";

  # Note: nixpkgs.config should be set at the system level when using
  # home-manager.useGlobalPkgs = true (which we do in NixOS configs)

  # Environment variables
  home.sessionVariables = {
    EDITOR = "nvim";
    TERMINAL = "kitty";
  };

  # Set fish as the default shell (managed by home-manager)
  home.preferXdgDirectories = true;

  # Fonts
  home.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  # Cursor theme (works for both X11 and Wayland, only on graphical systems)
  home.pointerCursor =
    lib.mkIf
      (osConfig.services.xserver.enable || osConfig.services.displayManager.cosmic-greeter.enable)
      {
        enable = true;
        name = "Posy_Cursor_Black";
        package = pkgs.posy-cursors;
        # Use smaller cursor size for Wayland; X11 can scale via XCURSOR_SIZE env var
        size = 32;
      };

  # Let home-manager manage itself
  programs.home-manager.enable = true;
}

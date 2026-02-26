# Shared packages across all machines
{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Shell and terminal
    fish
    kitty

    # Editor
    neovim

    # Browser
    brave

    # Git and version control
    git
    lazygit

    # CLI tools
    ripgrep
    fd
    eza          # Modern replacement for exa (which is no longer maintained)
    zoxide

    # Utilities
    curl
    wget
    tmux
    unzip
    which

    # Nix utilities
    any-nix-shell  # Makes nix-shell use your current shell (fish in our case)
    
    # Prompt
    starship  # Modern, fast, customizable prompt
  ];
}

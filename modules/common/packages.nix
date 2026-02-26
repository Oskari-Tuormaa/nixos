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
    exa
    zoxide

    # Utilities
    curl
    wget
    tmux
    unzip
    which
  ];
}

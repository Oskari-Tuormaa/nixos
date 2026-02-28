# Shared packages across all machines
{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Shell and terminal
    fish
    kitty

    # Editor
    neovim
    tree-sitter
    nodejs_24

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
    fzf          # Fuzzy finder for command line

    # Utilities
    curl
    wget
    tmux
    unzip
    which

    # Nix utilities
    any-nix-shell  # Makes nix-shell use your current shell (fish in our case)

    # AI coding assistant
    opencode

    # Prompt
    starship  # Modern, fast, customizable prompt
  ];
}

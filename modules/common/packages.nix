# Shared packages across all machines
{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Shell
    fish

    # Editor
    neovim

    # Neovim plugin dependencies
    tree-sitter
    nodejs_24
    imagemagick

    # Git and version control
    git
    lazygit

    # CLI tools
    ripgrep
    fd
    eza # Modern replacement for exa (which is no longer maintained)
    zoxide
    fzf # Fuzzy finder for command line
    bat

    # Utilities
    curl
    wget
    tmux
    unzip
    which
    trash-cli
    xclip
    gcc
    gnumake

    # Nix utilities
    any-nix-shell # Makes nix-shell use your current shell (fish in our case)
    nixfmt # Formatter for Nix code

    # AI coding assistant
    opencode

    # Prompt
    starship # Modern, fast, customizable prompt
  ];
}

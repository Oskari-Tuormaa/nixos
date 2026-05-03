# Shared packages across all machines
_: {
  flake.nixosModules.packages =
    { pkgs, ... }:
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

        # Neovim language servers
        clang-tools
        cmake-language-server
        nixd
        lua-language-server
        pyright
        rust-analyzer

        # Neovim formatters
        nixfmt
        black
        clang-tools

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
        ncdu
        bottom

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
        cloudflared # Cloudflare tunnel client for SSH access
        zip
        htop
        file

        # Nix utilities
        any-nix-shell # Makes nix-shell use your current shell (fish in our case)
        nix-ld

        # AI coding assistant
        opencode

        # Prompt
        starship # Modern, fast, customizable prompt
      ];
    };
}

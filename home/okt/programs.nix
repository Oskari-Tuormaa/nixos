# Program configurations for user 'okt'
{
  config,
  pkgs,
  lib,
  wallpaperPath,
  ...
}:

{
  imports = [
    ./i3.nix
    ./rofi.nix
  ];
  # Fish shell - configured in home-manager
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      # Fish shell configuration
      set fish_greeting

      # Enable VI key bindings
      fish_vi_key_bindings

      # Add useful abbreviations
      abbr -a ll ls -la
      abbr -a la ls -la
      abbr -a mkdir mkdir -p
      abbr v nvim
      abbr sv sudoedit
      abbr lg lazygit
      abbr rm trash

      # Useful aliases
      alias ls exa

      # Enable any-nix-shell for proper nix-shell support
      # This makes nix-shell/nix run use fish instead of dropping to bash
      ${pkgs.any-nix-shell}/bin/any-nix-shell fish --info-right | source
    '';
    loginShellInit = "";
  };

  # Neovim
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  # Kitty terminal
  programs.kitty = {
    enable = true;
    themeFile = "Dracula";
    settings = {
      font_family = "JetBrainsMono Nerd Font";
      font_size = 12;
      window_padding_width = 6;
    };
  };

  # Git configuration
  programs.git = {
    enable = true;
    # Use new settings format (userName and userEmail are deprecated)
    settings = {
      user = {
        name = "Oskari Kristian Tuormaa";
        email = "oskaritu@gmail.com";
      };
    };
    ignores = [
      "*~"
      "*.swp"
      ".DS_Store"
    ];
  };

  # Zoxide - fast directory navigation
  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
    options = [
      "--cmd cd"
    ];
  };

  # Direnv - load project-specific environments
  programs.direnv = {
    enable = true;
    enableFishIntegration = true;
    nix-direnv.enable = true;
  };

  # Starship prompt - modern, customizable prompt
  programs.starship = {
    enable = true;
  };

  # fzf - fuzzy finder for the command line
  programs.fzf = {
    enable = true;
    enableFishIntegration = true;

    # fzf options
    defaultOptions = [
      "--height 40%"
      "--border"
      "--info inline"
      "--preview-window right:50%"
    ];

    # File preview with bat if available
    fileWidgetOptions = [
      "--preview 'head -100 {}'"
      "--preview-window right:50%"
    ];
  };
}

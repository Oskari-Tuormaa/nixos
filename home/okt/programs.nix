# Program configurations for user 'okt'
{
  config,
  osConfig,
  pkgs,
  lib,
  wallpaperPath,
  ...
}:

{
  # Fish shell - configured in home-manager
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      # Fish shell configuration
      set fish_greeting

      # Environment variables
      set -x EDITOR nvim

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
      abbr z zathura

      # Useful aliases
      alias ls exa
      alias cat bat

      # Enable any-nix-shell for proper nix-shell support
      # This makes nix-shell/nix run use fish instead of dropping to bash
      ${pkgs.any-nix-shell}/bin/any-nix-shell fish --info-right | source
    '';
    loginShellInit = "";
  };

  # Kitty terminal
  programs.kitty = {
    enable = true;
    themeFile = "Dracula";
    settings = {
      font_family = "JetBrainsMono Nerd Font";
      # Scale font based on host DPI (default 96 = 12pt, 192 DPI = 24pt)
      font_size =
        if osConfig.services.xserver.dpi != null then 12 * osConfig.services.xserver.dpi / 96 else 12;
      window_padding_width = 6;
    };
    keybindings = {
      "ctrl+alt+enter" = "launch --type=os-window --cwd=current";
    };
  };

  # Git configuration
  programs.git = {
    enable = true;
    signing.format = null;
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

  # gh - GitHub CLI tool
  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
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

  programs.brave = {
    enable = true;
    package = pkgs.brave;
    extensions = [
      "nngceckbapebfimnlniiiahkandclblb" # Bitwarden
      "dbepggeogbaibhgnhhndojpepiihcmeb" # Vimium
      "gfapcejdoghpoidkfodoiiffaaibpaem" # Dracula color theme
      "eimadpbcbfnmbkopoojfekhnkhdbieeh" # Dark Reader
      "pccckmaobkjjboncdfnnofkonhgpceea" # Hover Zoom+
    ];
  };

  # Brave uses system GTK scaling via GDK_SCALE, so no override needed
  # The default desktop entry works fine with environment-based scaling

  # Override Steam desktop entry to add HiDPI scaling flag
  # Only on HiDPI systems (when dpi is set to high value)
  xdg.desktopEntries.steam =
    lib.mkIf
      (
        osConfig.services.xserver.enable
        && osConfig.services.xserver.dpi != null
        && osConfig.services.xserver.dpi > 120
      )
      {
        name = "Steam";
        exec = "steam -forcedesktopscaling 2 %U";
        icon = "steam";
        categories = [
          "Game"
        ];
        type = "Application";
      };

  programs.opencode = {
    enable = true;
    tui = {
      theme = "dracula";
    };
  };
}

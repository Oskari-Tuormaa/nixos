# Program configurations for user 'okt'
{ config, pkgs, lib, ... }:

{
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
    ignores = [ "*~" "*.swp" ".DS_Store" ];
  };

  # Zoxide - fast directory navigation
  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
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
    settings = {
      # Starship configuration
      format = "$username$hostname$directory$git_branch$git_status$nix_shell$cmd_duration$line_break$character";
      
      # Configure individual modules
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
      };
      
      directory = {
        truncation_length = 3;
        truncate_to_repo = true;
        home_symbol = "~";
      };
      
      git_branch = {
        symbol = " ";
        format = "on [$symbol$branch(:$remote_name)]($style) ";
      };
      
      git_status = {
        format = "([$all_status$ahead_behind]($style) )?";
      };
      
      nix_shell = {
        symbol = "❄️ ";
        format = "via [$symbol]($style)";
      };
      
      username = {
        show_always = true;
        format = "[$user]($style)@";
      };
      
      hostname = {
        ssh_only = false;
        format = "[$hostname]($style) ";
      };
      
      cmd_duration = {
        min_time = 500;
        format = "took [$duration]($style) ";
      };
    };
  };

  # i3 window manager - set kitty as the default terminal
  xsession.windowManager.i3 = {
    enable = true;
    config = {
      modifier = "Mod4";
      terminal = "kitty";
      gaps = {
        inner = 10;
        outer = 5;
      };
      fonts = {
        names = [ "JetBrainsMono Nerd Font" ];
        size = 10.0;
      };
      # Dracula colour theme for window borders and bar
      colors = {
        focused         = { border = "#6272A4"; background = "#6272A4"; text = "#F8F8F2"; indicator = "#6272A4"; childBorder = "#6272A4"; };
        focusedInactive = { border = "#44475A"; background = "#44475A"; text = "#F8F8F2"; indicator = "#44475A"; childBorder = "#44475A"; };
        unfocused       = { border = "#282A36"; background = "#282A36"; text = "#BFBFBF"; indicator = "#282A36"; childBorder = "#282A36"; };
        urgent          = { border = "#44475A"; background = "#FF5555"; text = "#F8F8F2"; indicator = "#FF5555"; childBorder = "#FF5555"; };
        placeholder     = { border = "#282A36"; background = "#282A36"; text = "#F8F8F2"; indicator = "#282A36"; childBorder = "#282A36"; };
        background      = "#F8F8F2";
      };
      bars = [{
        fonts = {
          names = [ "JetBrainsMono Nerd Font" ];
          size = 10.0;
        };
        statusCommand = "i3status";
        colors = {
          background  = "#282A36";
          statusline  = "#F8F8F2";
          separator   = "#44475A";
          focusedWorkspace  = { border = "#44475A"; background = "#44475A"; text = "#F8F8F2"; };
          activeWorkspace   = { border = "#282A36"; background = "#44475A"; text = "#F8F8F2"; };
          inactiveWorkspace = { border = "#282A36"; background = "#282A36"; text = "#BFBFBF"; };
          urgentWorkspace   = { border = "#FF5555"; background = "#FF5555"; text = "#F8F8F2"; };
          bindingMode       = { border = "#FF5555"; background = "#FF5555"; text = "#F8F8F2"; };
        };
      }];
      # Vim motions for focus and window movement
      keybindings = let modifier = "Mod4"; in lib.mkOptionDefault {
        "${modifier}+h" = "focus left";
        "${modifier}+j" = "focus down";
        "${modifier}+k" = "focus up";
        "${modifier}+l" = "focus right";
        "${modifier}+Shift+h" = "move left";
        "${modifier}+Shift+j" = "move down";
        "${modifier}+Shift+k" = "move up";
        "${modifier}+Shift+l" = "move right";
      };
    };
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

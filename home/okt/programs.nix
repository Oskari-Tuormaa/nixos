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
    ignores = [ "*~" "*.swp" ".DS_Store" ];
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
      # Vim motions for focus and window movement; rofi launcher on Mod4+p
      keybindings = let modifier = "Mod4"; in lib.mkOptionDefault {
        "${modifier}+h" = "focus left";
        "${modifier}+j" = "focus down";
        "${modifier}+k" = "focus up";
        "${modifier}+l" = "focus right";
        "${modifier}+Shift+h" = "move left";
        "${modifier}+Shift+j" = "move down";
        "${modifier}+Shift+k" = "move up";
        "${modifier}+Shift+l" = "move right";
        # Replace default dmenu (Mod4+d) with rofi on Mod4+p
        "${modifier}+d" = null;
        "${modifier}+p" = "exec rofi -modes drun,run,window -show drun";
        # Screenshot with flameshot
        "${modifier}+Shift+s" = "exec flameshot gui";
        # Open browser
        "${modifier}+Shift+f" = "exec brave";
      };
    };
  };

  # Rofi - application launcher with Dracula theme
  programs.rofi = {
    enable = true;
    font = "JetBrainsMono Nerd Font 12";
    theme = let m = config.lib.formats.rasi.mkLiteral; in {
      "*" = {
        foreground          = m "#F8F8F2";
        background-color    = m "#282A36";
        active-background   = m "#6272A4";
        urgent-background   = m "#FF5555";
        urgent-foreground   = m "#282A36";
        selected-background = m "@active-background";
        selected-urgent-background = m "@urgent-background";
        selected-active-background = m "@active-background";
        separatorcolor      = m "@active-background";
        bordercolor         = m "@active-background";
      };
      "window" = {
        background-color = m "@background-color";
        border           = m "3";
        border-radius    = m "6px";
        border-color     = m "@bordercolor";
        padding          = m "15";
      };
      "element.normal.normal"    = { background-color = m "@background-color"; text-color = m "@foreground"; };
      "element.normal.urgent"    = { background-color = m "@urgent-background"; text-color = m "@urgent-foreground"; };
      "element.normal.active"    = { background-color = m "@active-background"; text-color = m "@foreground"; };
      "element.selected.normal"  = { background-color = m "@selected-background"; text-color = m "@foreground"; };
      "element.selected.urgent"  = { background-color = m "@selected-urgent-background"; text-color = m "@foreground"; };
      "element.selected.active"  = { background-color = m "@selected-active-background"; text-color = m "@foreground"; };
      "element-text, element-icon" = { background-color = m "inherit"; text-color = m "inherit"; };
      "inputbar" = { children = m "[ prompt, textbox-prompt-colon, entry, case-indicator ]"; };
      "textbox-prompt-colon" = { expand = false; str = ">"; text-color = m "@foreground"; };
    };
    extraConfig = {
      show-icons      = true;
      display-drun    = "";
      disable-history = false;
      modi            = "drun";
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

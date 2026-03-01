# i3 window manager configuration
{
  config,
  pkgs,
  lib,
  wallpaperPath,
  ...
}:

let
  wallpaper = pkgs.copyPathToStore wallpaperPath;
in

{
  xsession.windowManager.i3 = {
    enable = true;
    config = {
      modifier = "Mod4";
      terminal = "kitty";
      gaps = {
        inner = 10;
        outer = 5;
      };
      floating.border = 3;
      window = {
        border = 3;
        titlebar = false;
      };
      fonts = {
        names = [ "JetBrainsMono Nerd Font" ];
        size = 10.0;
      };
      # Dracula colour theme for window borders and bar
      colors = {
        focused = {
          border = "#6272A4";
          background = "#6272A4";
          text = "#F8F8F2";
          indicator = "#6272A4";
          childBorder = "#6272A4";
        };
        focusedInactive = {
          border = "#44475A";
          background = "#44475A";
          text = "#F8F8F2";
          indicator = "#44475A";
          childBorder = "#44475A";
        };
        unfocused = {
          border = "#282A36";
          background = "#282A36";
          text = "#BFBFBF";
          indicator = "#282A36";
          childBorder = "#282A36";
        };
        urgent = {
          border = "#44475A";
          background = "#FF5555";
          text = "#F8F8F2";
          indicator = "#FF5555";
          childBorder = "#FF5555";
        };
        placeholder = {
          border = "#282A36";
          background = "#282A36";
          text = "#F8F8F2";
          indicator = "#282A36";
          childBorder = "#282A36";
        };
        background = "#F8F8F2";
      };
      bars = [
        {
          fonts = {
            names = [ "JetBrainsMono Nerd Font" ];
            size = 10.0;
          };
          statusCommand = "i3status";
          colors = {
            background = "#282A36";
            statusline = "#F8F8F2";
            separator = "#44475A";
            focusedWorkspace = {
              border = "#44475A";
              background = "#44475A";
              text = "#F8F8F2";
            };
            activeWorkspace = {
              border = "#282A36";
              background = "#44475A";
              text = "#F8F8F2";
            };
            inactiveWorkspace = {
              border = "#282A36";
              background = "#282A36";
              text = "#BFBFBF";
            };
            urgentWorkspace = {
              border = "#FF5555";
              background = "#FF5555";
              text = "#F8F8F2";
            };
            bindingMode = {
              border = "#FF5555";
              background = "#FF5555";
              text = "#F8F8F2";
            };
          };
        }
      ];
      # Vim motions for focus and window movement; rofi launcher on Mod4+p
      keybindings =
        let
          modifier = "Mod4";
        in
        lib.mkOptionDefault {
          "${modifier}+h" = "focus left";
          "${modifier}+j" = "focus down";
          "${modifier}+k" = "focus up";
          "${modifier}+l" = "focus right";
          "${modifier}+Shift+h" = "move left";
          "${modifier}+Shift+j" = "move down";
          "${modifier}+Shift+k" = "move up";
          "${modifier}+Shift+l" = "move right";
          # Resize mode with Mod4+r, then hjkl to resize
          "${modifier}+r" = "mode resize";
          # Replace default dmenu (Mod4+d) with rofi on Mod4+p
          "${modifier}+d" = null;
          "${modifier}+p" = "exec rofi -modes 'drun#run#window' -show drun";
          # Screenshot with flameshot
          "${modifier}+Shift+s" = "exec flameshot gui";
          # Open browser
          "${modifier}+Shift+f" = "exec brave";
          # Swap to the previously focused workspace
          "${modifier}+Tab" = "workspace back_and_forth";
        };
      modes = {
        resize = {
          "h" = "resize shrink width 10 px or 10 ppt";
          "j" = "resize grow height 10 px or 10 ppt";
          "k" = "resize shrink height 10 px or 10 ppt";
          "l" = "resize grow width 10 px or 10 ppt";
          "Escape" = "mode default";
          "Return" = "mode default";
        };
      };
      startup = [
        # Set wallpaper on every i3 start/reload
        {
          command = "${pkgs.feh}/bin/feh --bg-fill ${wallpaper}";
          always = true;
          notification = false;
        }
      ];
    };
  };
}

# Hyprland window manager configuration
{
  config,
  pkgs,
  lib,
  wallpaperPath,
  ...
}:

let
  modifier = "SUPER";
in

{
  wayland.windowManager.hyprland = {
    enable = true;
    package = null; # Use the NixOS package
    systemd.enable = false; # Avoid the buggy systemd session

    settings = {
      general = {
        gaps_in = 10;
        gaps_out = 5;
        border_size = 3;
        resize_on_border = true;
        layout = "dwindle";
      };

      # Decoration settings
      decoration = {
        rounding = 0;
        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
          color = "rgba(00000045)";
          offset = "0 5";
        };
        blur = {
          enabled = false;
        };
      };

      # Input device configuration
      input = {
        kb_layout = "us";
        follow_mouse = 1;
        sensitivity = 0.0;
        force_no_accel = false;
      };

      # Keybindings with vim motions
      bind = [
        # Window focus and movement (vim motions)
        "${modifier}, h, movefocus, l"
        "${modifier}, j, movefocus, d"
        "${modifier}, k, movefocus, u"
        "${modifier}, l, movefocus, r"

        "${modifier} SHIFT, h, movewindow, l"
        "${modifier} SHIFT, j, movewindow, d"
        "${modifier} SHIFT, k, movewindow, u"
        "${modifier} SHIFT, l, movewindow, r"

        # Workspace switching
        "${modifier}, 1, workspace, 1"
        "${modifier}, 2, workspace, 2"
        "${modifier}, 3, workspace, 3"
        "${modifier}, 4, workspace, 4"
        "${modifier}, 5, workspace, 5"
        "${modifier}, 6, workspace, 6"
        "${modifier}, 7, workspace, 7"
        "${modifier}, 8, workspace, 8"
        "${modifier}, 9, workspace, 9"
        "${modifier}, 0, workspace, 10"

        # Move window to workspace
        "${modifier} SHIFT, 1, movetoworkspace, 1"
        "${modifier} SHIFT, 2, movetoworkspace, 2"
        "${modifier} SHIFT, 3, movetoworkspace, 3"
        "${modifier} SHIFT, 4, movetoworkspace, 4"
        "${modifier} SHIFT, 5, movetoworkspace, 5"
        "${modifier} SHIFT, 6, movetoworkspace, 6"
        "${modifier} SHIFT, 7, movetoworkspace, 7"
        "${modifier} SHIFT, 8, movetoworkspace, 8"
        "${modifier} SHIFT, 9, movetoworkspace, 9"
        "${modifier} SHIFT, 0, movetoworkspace, 10"

        # Application launching
        "${modifier}, Return, exec, kitty"

        # Screenshot with flameshot
        "${modifier} SHIFT, s, exec, flameshot gui"

        # Open browser
        "${modifier} SHIFT, f, exec, brave"

        # Toggle floating
        "${modifier}, space, togglefloating"

        # Split controls (toggle split direction)
        "${modifier}, n, layoutmsg, orientationleft"
        "${modifier}, m, layoutmsg, orientationtop"

        # Resize mode (similar to i3 resize mode)
        "${modifier}, r, submap, resize"

        # Swap to previously focused workspace
        "${modifier}, Tab, workspace, previous"

        # Close window
        "${modifier}, w, killactive"

        # Exit Hyprland
        "${modifier} SHIFT, e, exit"
      ];

      # Start hyprpaper and dunst on launch
      exec-once = [
        "hyprpaper"
        "dunst"
      ];
    };

    # Environment variables for Wayland
    systemd.variables = [ "--all" ];
  };
}

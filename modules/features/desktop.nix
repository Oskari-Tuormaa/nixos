{
  flake.nixosModules.desktop =
    { pkgs, ... }:
    {
      services.displayManager.ly.enable = true;

      services.xserver = {
        enable = true;
        windowManager.i3.enable = true;
        autoRepeatDelay = 250;
        autoRepeatInterval = 25;
        xkb = {
          layout = "us,dk";
          options = "grp:alt_space_toggle,caps:swapescape";
        };
      };

      services.pipewire = {
        enable = true;
        alsa.enable = true;
        pulse.enable = true;
      };

      # udisks2 is the D-Bus backend required by udiskie (managed as a user service via Home Manager)
      services.udisks2.enable = true;

      environment.systemPackages = with pkgs; [
        # Screenshots
        flameshot

        # Application runner
        rofi

        # Terminal
        kitty

        # File browser
        nemo

        # PDF Reader
        zathura

        # Audio control interface
        pavucontrol
        pulseaudio

        # Volume and brightness control
        brightnessctl

        # Assorted GUI programs
        spotify
        discord
        teams-for-linux

        # Misc
        feh

        # Window manager
        i3
        i3status
        picom
        redshift
      ];
    };
}

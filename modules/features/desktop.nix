{ ... }: {
  flake.modules.nixos.desktop =
    {
      pkgs,
      ...
    }:
    {
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        pulse.enable = true;
      };

      # udisks2 is the D-Bus backend required by udiskie (managed as a user service via Home Manager)
      services.udisks2.enable = true;

      environment.systemPackages = with pkgs; [
        # Screen recorder
        peek

        # Browser
        firefox

        # Notes
        obsidian

        # Terminal
        kitty

        # Document editing
        libreoffice

        # Audio control interface
        pavucontrol
        pulseaudio

        # CAD
        freecad

        # Assorted GUI programs
        spotify
        discord
        teams-for-linux
        gimp
        darktable
        bitwig-studio
        blender
        prismlauncher

        # Misc
        feh

        # Cursor theme
        posy-cursors
      ];
    };
}

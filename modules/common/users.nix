# User configuration common to all machines
_: {
  flake.nixosModules.users =
    { pkgs, ... }:
    {
      # Create the okt user with fish as default shell
      users.users.okt = {
        isNormalUser = true;
        home = "/home/okt";
        shell = pkgs.fish; # Set fish as default shell
        extraGroups = [
          "wheel" # Allow sudo
          "dialout" # Access serial/USB devices (ST-Link, Arduino, etc.) without sudo
          "netdev" # Access networking (nmcli) without sudo
        ];
        initialHashedPassword = "$y$j9T$GP.9etffB2GttjTvF7gEw0$OK/KzBwFcz7iFufUtYg9SnBrp7IvyRTIKjNafyYC2QC";
      };

      # Suppress the shell program check warning since we're setting fish
      # in both system and home-manager configs (which is safe)
      users.users.okt.ignoreShellProgramCheck = true;
    };
}

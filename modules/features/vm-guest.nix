# VirtualBox guest support
_: {
  flake.nixosModules."vm-guest" =
    { pkgs, ... }:
    {
      virtualisation.virtualbox.guest.enable = true;

      environment.systemPackages = with pkgs; [
        virtualbox-guest-additions
      ];

      # Enable clipboard sharing with host
      virtualisation.virtualbox.guest.clipboard = true;
    };
}

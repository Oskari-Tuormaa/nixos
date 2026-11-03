{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    packet
  ];

  # Open discovery port
  networking.firewall.allowedTCPPorts = [ 9300 ];

  # Enable local network discovery
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    publish = {
      enable = true;
      addresses = true;
      workstation = true;
    };
  };
}


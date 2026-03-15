# Agenix secrets configuration
# This file defines which SSH public keys can decrypt each secret
# Public keys are SAFE to commit to git

let
  # To get a host's public key, run on that machine:
  # cat /etc/ssh/ssh_host_ed25519_key.pub

  # Host public keys - collect from each machine
  # Run on each host: cat /etc/ssh/ssh_host_ed25519_key.pub
  # TODO: Add hosts
  lovelace = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEwcUYz2Y/F9yH2M8E5bUAqqyBA5aYIB8iOgqCpAWF4U";

  # Groups of keys for easy management
  allHosts = [
    lovelace
  ];
  desktopHosts = [
    lovelace
  ];
  # serverHosts = [ perlman ];

in
{
  # GitHub SSH key
  "github-ssh-key.age".publicKeys = allHosts;

  # Mjoelner Azure SSH key
  "mjolner-dev-ssh-key.age".publicKeys = allHosts;
}

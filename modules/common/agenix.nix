# Agenix secrets management - bootstrapping disabled for fresh NixOS installs
{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:

{
  # Import agenix module from flake input
  imports = [ inputs.agenix.nixosModules.default ];

  # Make agenix CLI available in system packages
  environment.systemPackages = with pkgs; [
    inputs.agenix.packages.${pkgs.system}.agenix
  ];

  # Configure secrets - only load on machines that have already been bootstrapped
  # Skip on fresh NixOS installs (which have hostname "nixos" by default)
  age.secrets = lib.mkIf (config.networking.hostName != "nixos") {
    github-ssh-key = {
      file = ../../secrets/github-ssh-key.age;
      owner = "okt";
      group = "users";
      mode = "0600";
      path = "/run/secrets/github-ssh-key";
    };
    mjolner-dev-ssh-key = {
      file = ../../secrets/mjolner-dev-ssh-key.age;
      owner = "okt";
      group = "users";
      mode = "0600";
      path = "/run/secrets/mjolner-dev-ssh-key";
    };
    perlman-ssh-key = {
      file = ../../secrets/perlman-ssh-key.age;
      owner = "okt";
      group = "users";
      mode = "0600";
      path = "/run/secrets/perlman-ssh-key";
    };
  };

  # Use SSH host key for decryption during nixos-rebuild
  age.identityPaths = [
    "/etc/ssh/ssh_host_ed25519_key"
    "/etc/ssh/ssh_host_rsa_key"
  ];
}

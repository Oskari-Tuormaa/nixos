# Agenix secrets management - bootstrapping disabled for fresh NixOS installs
{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:

let
  SSHKeyNames = map (name: "${name}-ssh-key") [
    "github"
    "mjolnerdev"
    "perlman"
  ];

  SSHSecrets = lib.genAttrs SSHKeyNames (name: {
    file = ../../secrets/${name}.age;
    owner = "okt";
    group = "users";
    mode = "0600";
    path = "/run/secrets/${name}";
  });
in
{
  # Import agenix module from flake input
  imports = [ inputs.agenix.nixosModules.default ];

  # Make agenix CLI available in system packages
  environment.systemPackages = with pkgs; [
    inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.agenix
  ];

  # Configure secrets - only load on machines that have already been bootstrapped
  # Skip on fresh NixOS installs (which have hostname "nixos" by default)
  age.secrets = lib.mkIf (config.networking.hostName != "nixos") SSHSecrets;

  # Use SSH host key for decryption during nixos-rebuild
  age.identityPaths = [
    "/etc/ssh/ssh_host_ed25519_key"
    "/etc/ssh/ssh_host_rsa_key"
  ];
}

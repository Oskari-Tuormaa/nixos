# Home Manager secrets configuration
# Links decrypted secrets from agenix to user's home directory
{
  config,
  osConfig,
  lib,
  ...
}:
let
  SSHKeys = [
    "github"
    "mjolnerdev"
    "perlman"
  ];

  SSHKeySymlinks = builtins.listToAttrs (
    map (key_name: {
      name = ".ssh/id_${key_name}";
      value = {
        source = config.lib.file.mkOutOfStoreSymlink osConfig.age.secrets."${key_name}-ssh-key".path;
        executable = false;
      };
    }) SSHKeys
  );

in
{
  # Only configure if agenix secrets are available (not on fresh nixos installs)
  home.file = lib.mkIf (osConfig.networking.hostName != "nixos") SSHKeySymlinks;
}

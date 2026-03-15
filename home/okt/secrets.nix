# Home Manager secrets configuration
# Links decrypted secrets from agenix to user's home directory
{
  config,
  osConfig,
  lib,
  ...
}:

{
  # Only configure if agenix secrets are available (not on fresh nixos installs)
  home.file = lib.mkIf (osConfig.networking.hostName != "nixos") {
    ".ssh/id_github" = {
      source = config.lib.file.mkOutOfStoreSymlink osConfig.age.secrets.github-ssh-key.path;
      executable = false;
    };
    ".ssh/id_mjolner_dev" = {
      source = config.lib.file.mkOutOfStoreSymlink osConfig.age.secrets.mjolner-dev-ssh-key.path;
      executable = false;
    };
  };
}

# SSH configuration with Cloudflare tunnel support
{
  config,
  pkgs,
  lib,
  ...
}:

{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      "*" = {
        addKeysToAgent = "yes";
        identityFile = [
          "~/.ssh/id_rsa"
        ];
        identitiesOnly = true;
      };
      "github.com" = {
        hostname = "github.com";
        user = "git";
        identityFile = [ "~/.ssh/id_github" ];
        identitiesOnly = true;
      };
      "ssh.dev.azure.com" = {
        hostname = "ssh.dev.azure.com";
        user = "git";
        identityFile = [ "~/.ssh/id_mjolner_dev" ];
        identitiesOnly = true;
      };
      "tuormaa.net" = {
        proxyCommand = "${pkgs.cloudflared}/bin/cloudflared access ssh --hostname %h";
        identityFile = [ "~/.ssh/id_perlman" ];
      };
    };
  };
}

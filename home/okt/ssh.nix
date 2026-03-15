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
          "~/.ssh/id_github"
        ];
        identitiesOnly = true;
      };
      "tuormaa.net" = {
        proxyCommand = "${pkgs.cloudflared}/bin/cloudflared access ssh --hostname %h";
      };
    };
  };
}

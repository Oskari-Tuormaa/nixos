# Program configurations for user 'okt'
{ config, pkgs, ... }:

{
  # Fish shell - configured in home-manager
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      # Fish shell configuration
      set fish_greeting
      
      # Add useful abbreviations
      abbr -a ll ls -la
      abbr -a la ls -la
      abbr -a mkdir mkdir -p
    '';
    loginShellInit = "";
  };

  # Neovim
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  # Kitty terminal
  programs.kitty = {
    enable = true;
    settings = {
      font_family = "monospace";
      font_size = 12;
    };
  };

  # Git configuration
  programs.git = {
    enable = true;
    userName = "okt";  # Will be moved to settings.user.name soon
    userEmail = "okt@localhost"; # TODO: Update with your email (will be moved to settings.user.email)
    # Using new settings format for future compatibility
    extraConfig = {
      user = {
        name = "okt";
        email = "okt@localhost";
      };
    };
    ignores = [ "*~" "*.swp" ".DS_Store" ];
  };

  # Zoxide - fast directory navigation
  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  # Direnv - load project-specific environments
  programs.direnv = {
    enable = true;
    enableFishIntegration = true;
    nix-direnv.enable = true;
  };
}

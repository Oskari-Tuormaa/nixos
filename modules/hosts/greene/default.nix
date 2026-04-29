# Greene: WSL2 NixOS Test Host (Headless)
# A safe sandbox for learning NixOS, testing the flake, and development work
# Before using this, install NixOS-WSL manually:
# 1. Download nixos-wsl.tar.gz from https://github.com/nix-community/NixOS-WSL/releases
# 2. From PowerShell: wsl --import greene . C:\path\to\nixos-wsl.tar.gz --version 2
# 3. Deploy: sudo nixos-rebuild switch --flake .#greene
{ self, inputs, ... }:

{
  flake.nixosConfigurations.greene = self.lib.mkHost {
    hostname = "greene";
    system = "x86_64-linux";
    cpuCoreCount = 8;
    modules = [
      inputs.nixos-wsl.nixosModules.default
      self.nixosModules.packages
      self.nixosModules.settings
      self.nixosModules.users
      self.nixosModules.agenix
      self.nixosModules."greene-hardware"
      {
        networking.hostName = "greene";

        # Allow unfree packages (needed for some packages like brave)
        nixpkgs.config.allowUnfree = true;

        # WSL-specific configuration
        # The nixos-wsl module is added above and provides defaults
        # These settings override/customize the module behavior
        wsl = {
          enable = true;
          defaultUser = "okt";
          # Note: nativeSystemd is now always enabled by default in nixos-wsl
        };

        # Disable graphics since this is headless
        services.xserver.enable = false;

        # Enable SSH for remote access if needed
        services.openssh = {
          enable = true;
          settings.PasswordAuthentication = true;
        };
      }
    ];
  };
}

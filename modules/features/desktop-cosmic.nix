{ self, ... }: {
  flake.modules.nixos.desktop-cosmic = { ... }: {
    imports = [ self.modules.nixos.desktop ];
    services = {
      desktopManager.cosmic.enable = true;
      displayManager.cosmic-greeter.enable = true;
      system76-scheduler.enable = true;
    };
  };
}

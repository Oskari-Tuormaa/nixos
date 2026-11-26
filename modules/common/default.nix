{ self, ... }: {
  flake.modules.nixos.common = { ... }: {
    imports = [
      self.modules.nixos.users
      self.modules.nixos.settings
      self.modules.nixos.keyd
      self.modules.nixos.packages
    ];
  };
}

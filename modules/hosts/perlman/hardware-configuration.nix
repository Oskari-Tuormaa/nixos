# Perlman hardware configuration — placeholder until nixos-generate-config is run on hardware
# TODO: Replace with actual hardware-configuration.nix after running nixos-generate-config
_: {
  flake.nixosModules."perlman-hardware" =
    { modulesPath, ... }:
    {
      imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

      # Minimal placeholder filesystem configuration
      fileSystems."/" = {
        device = "/dev/null";
        fsType = "tmpfs";
      };

      boot.loader.grub.devices = [ "/dev/sda" ];
    };
}

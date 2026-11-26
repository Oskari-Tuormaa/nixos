{ ... }: {
  flake.modules.nixos.fingerprint =
    { pkgs, ... }:
    {
      services.fprintd.enable = true;

      environment.systemPackages = with pkgs; [
        enroll
      ];
    };
}

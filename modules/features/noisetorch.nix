{ ... }: {
  flake.modules.nixos.noisetorch =
    { ... }:
    {
      programs.noisetorch.enable = true;
    };
}

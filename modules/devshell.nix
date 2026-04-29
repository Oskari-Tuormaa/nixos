# Development environment for NixOS configuration
_: {
  perSystem =
    { pkgs, ... }:
    {
      devShells.default = pkgs.mkShell {
        description = "Development environment for NixOS configuration";
        buildInputs = with pkgs; [
          nixfmt
          git
          just
        ];
      };
    };
}

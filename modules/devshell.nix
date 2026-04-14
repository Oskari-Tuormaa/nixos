{ ... }:
{
  systems = [ "x86_64-linux" ];
  perSystem =
    { pkgs, ... }:
    {
      devShells.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          nixfmt
          git
          just
        ];
      };
    };
}

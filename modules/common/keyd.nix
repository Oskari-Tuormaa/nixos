# Key remapping daemon — caps/esc swap and alt layer for Nordic characters
{ ... }:
{
  services.keyd = {
    enable = true;
    keyboards.default = {
      ids = [ "*" ];
      settings = {
        main = {
          capslock = "esc";
          esc = "capslock";
        };
      };
    };
  };
}

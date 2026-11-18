# Glyphie emoji picker for COSMIC
{ pkgs, ... }:
{
  environment.systemPackages = [
    (pkgs.callPackage ../../pkgs/glyphie { })
  ];
}

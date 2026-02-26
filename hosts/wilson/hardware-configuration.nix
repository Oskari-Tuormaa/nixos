# Wilson hardware configuration
# Generate with: nixos-generate-config --root /mnt
# This is a placeholder - will be replaced when you install NixOS on wilson

{ config, lib, pkgs, ... }:

{
  imports = [ <nixpkgs/nixos/modules/installer/scan/not-detected.nix> ];

  # TODO: Replace with actual hardware-configuration.nix after running nixos-generate-config
}

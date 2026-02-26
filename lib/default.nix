# Library helpers for multi-host NixOS configuration
{ lib, inputs }:

{
  mkHost = import ./mkHost.nix { inherit inputs lib; };
  mkHome = import ./mkHome.nix { inherit inputs lib; };
}

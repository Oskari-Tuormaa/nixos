# Library helpers for multi-host NixOS configuration
rec {
  mkHost = import ./mkHost.nix;
  mkHome = import ./mkHome.nix;
}

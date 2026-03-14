# Hedy: QEMU/KVM Test Host (Linux KVM)
# A testing sandbox for NixOS configuration on Linux systems using QEMU/KVM
{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/common
    ../../modules/features/desktop.nix
    ../../modules/features/desktop-i3.nix
  ];

  networking.hostName = "hedy";

  # Allow unfree packages (needed for some packages like brave)
  nixpkgs.config.allowUnfree = true;

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";
  boot.loader.grub.useOSProber = true;

  # X11 video driver for Virtio GPU (KVM/QEMU)
  # Modesetting driver provides KMS support and proper display detection
  # Explicitly disable vesa and fbdev fallbacks which can cause issues
  services.xserver.videoDrivers = [ "modesetting" ];
  services.xserver.excludePackages = with pkgs.xorg; [
    xf86videofbdev
    xf86videovesa
  ];

  # QEMU/KVM guest integration for display resizing and clipboard
  # Both system-wide daemon and per-user agent are needed for full functionality
  services.spice-vdagentd.enable = true;
  services.qemuGuest.enable = true;

  # Add SPICE packages to system
  environment.systemPackages = with pkgs; [
    spice-vdagent
    spice-autorandr
  ];

  # Create user-level systemd service for spice-vdagent
  # This is needed in addition to spice-vdagentd for proper SPICE integration
  systemd.user.services.spice-vdagent = {
    description = "SPICE guest agent";
    after = [ "graphical-session-pre.target" ];
    wantedBy = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.spice-vdagent}/bin/spice-vdagent -x";
      Restart = "on-failure";
      RestartSec = 5;
    };
  };

  # Create user-level systemd service for spice-autorandr
  # Monitors XRandR events and automatically applies resolution changes for i3
  systemd.user.services.spice-autorandr = {
    description = "SPICE automatic display resize for i3";
    after = [ "spice-vdagent.service" ];
    wantedBy = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.spice-autorandr}/bin/spice-autorandr";
      Restart = "on-failure";
      RestartSec = 5;
    };
  };
}

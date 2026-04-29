# Udev rules for STMicroelectronics USB devices (ST-Link, STM32, virtual COM ports)
_: {
  flake.nixosModules.stlink =
    { ... }:
    {
      services.udev.extraRules = ''
        # Grant dialout group access to all STMicroelectronics USB devices.
        # Covers ST-Link programmers, STM32 DFU mode, and CDC ACM serial ports.
        SUBSYSTEM=="usb", ATTRS{idVendor}=="0483", MODE="0660", GROUP="dialout"
        SUBSYSTEM=="tty", ATTRS{idVendor}=="0483", MODE="0660", GROUP="dialout"
      '';
    };
}

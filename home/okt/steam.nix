# Steam configuration for user 'okt'
# Configures shader compilation threading and HiDPI UI scaling
{
  osConfig,
  cpuCoreCount,
  pkgs,
  lib,
  ...
}:

lib.mkIf osConfig.programs.steam.enable {
  home.file.".steam/steam/steam_dev.cfg".text = ''
    unShaderBackgroundProcessingThreads ${builtins.toString cpuCoreCount}
  '';

  # Configure Steam UI scale for HiDPI displays
  # On high-DPI systems (192 DPI = 200%), set UI scale to 2.0 for readability
  home.activation.steamUIScale =
    let
      shouldScale = osConfig.services.xserver.dpi != null && osConfig.services.xserver.dpi >= 192;
      uiScale = if shouldScale then "1.5" else "1.0";
    in
    lib.mkIf shouldScale (
      lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        CONFIG_FILE="$HOME/.steam/steam/config/config.vdf"
        if [ -f "$CONFIG_FILE" ]; then
          # Use sed to update or add DesktopUIScale in Accessibility section
          if grep -q "DesktopUIScale" "$CONFIG_FILE"; then
            ${pkgs.gnused}/bin/sed -i 's/"DesktopUIScale".*/"DesktopUIScale"\t\t"${uiScale}"/' "$CONFIG_FILE"
          else
            # Add it after "Accessibility" line if not present
            ${pkgs.gnused}/bin/sed -i '/^\t"Accessibility"$/a\t\t"DesktopUIScale"\t\t"${uiScale}"' "$CONFIG_FILE"
          fi
        fi
      ''
    );
}

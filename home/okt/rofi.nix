# Rofi - application launcher with Dracula theme
{
  config,
  pkgs,
  ...
}:

{
  programs.rofi = {
    enable = true;
    font = "JetBrainsMono Nerd Font 12";
    theme =
      let
        m = config.lib.formats.rasi.mkLiteral;
      in
      {
        "*" = {
          font = m "\"Jetbrains Mono 12\"";
          foreground = m "#f8f8f2";
          background-color = m "#282a36";
          active-background = m "#6272a4";
          urgent-background = m "#ff5555";
          urgent-foreground = m "#282a36";
          selected-background = m "@active-background";
          selected-urgent-background = m "@urgent-background";
          selected-active-background = m "@active-background";
          separatorcolor = m "@active-background";
          bordercolor = m "@active-background";
        };
        "window" = {
          background-color = m "@background-color";
          border = m "3";
          border-radius = m "6";
          border-color = m "@bordercolor";
          padding = m "15";
        };
        "mainbox" = {
          border = m "0";
          padding = m "0";
        };
        "message" = {
          border = m "0px";
          border-color = m "@separatorcolor";
          padding = m "1px";
        };
        "textbox" = {
          text-color = m "@foreground";
        };
        "listview" = {
          fixed-height = m "0";
          border = m "0px";
          border-color = m "@bordercolor";
          spacing = m "2px";
          scrollbar = m "false";
          padding = m "2px 0px 0px";
        };
        "element" = {
          border = m "0";
          padding = m "3px";
        };
        "element.normal.normal" = {
          background-color = m "@background-color";
          text-color = m "@foreground";
        };
        "element.normal.urgent" = {
          background-color = m "@urgent-background";
          text-color = m "@urgent-foreground";
        };
        "element.normal.active" = {
          background-color = m "@active-background";
          text-color = m "@foreground";
        };
        "element.selected.normal" = {
          background-color = m "@selected-background";
          text-color = m "@foreground";
        };
        "element.selected.urgent" = {
          background-color = m "@selected-urgent-background";
          text-color = m "@foreground";
        };
        "element.selected.active" = {
          background-color = m "@selected-active-background";
          text-color = m "@foreground";
        };
        "element.alternate.normal" = {
          background-color = m "@background-color";
          text-color = m "@foreground";
        };
        "element.alternate.urgent" = {
          background-color = m "@urgent-background";
          text-color = m "@foreground";
        };
        "element.alternate.active" = {
          background-color = m "@active-background";
          text-color = m "@foreground";
        };
        "scrollbar" = {
          width = m "2px";
          border = m "0";
          handle-width = m "8px";
          padding = m "0";
        };
        "sidebar" = {
          border = m "2px dash 0px 0px";
          border-color = m "@separatorcolor";
        };
        "button.selected" = {
          background-color = m "@selected-background";
          text-color = m "@foreground";
        };
        "inputbar" = {
          spacing = m "0";
          text-color = m "@foreground";
          padding = m "1px";
          children = m "[ prompt, textbox-prompt-colon, entry, case-indicator ]";
        };
        "case-indicator" = {
          spacing = m "0";
          text-color = m "@foreground";
        };
        "entry" = {
          spacing = m "0";
          text-color = m "@foreground";
        };
        "prompt" = {
          spacing = m "0";
          text-color = m "@foreground";
        };
        "textbox-prompt-colon" = {
          expand = m "false";
          str = m "\">\"";
          margin = m "0px 0.3em 0em 0em";
          text-color = m "@foreground";
        };
        "element-text, element-icon" = {
          background-color = m "inherit";
          text-color = m "inherit";
        };
      };
    extraConfig = {
      show-icons = true;
      display-drun = "";
      disable-history = false;
      modi = "drun";
    };
  };
}

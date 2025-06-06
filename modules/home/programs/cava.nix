{ pkgs, ... }:
{
  programs.cava = {
    enable = true;
    settings = {
      general.autosens = 1;
      output.channels = "mono";
    };
  };
  wayland.windowManager.hyprland.plugins = [
    pkgs.hyprlandPlugins.hyprwinwrap
  ];
}

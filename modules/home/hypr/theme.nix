{ pkgs, ... }:
{
  gtk = {
    enable = true;
    cursorTheme = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
      size = 24;
    };
  };
  qt.enable = true;
  
  stylix.targets = {
    swaync.enable = false;
    hyprland.enable = false;
    hyprlock.useWallpaper = false;
    tofi.enable = false;
    waybar.enable = false;
  };
}

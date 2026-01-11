{ ... }:
{
  services.hyprpaper.enable = true;
  services.hyprpaper.settings = {
    preload = [ "${./assets/bg.png}" ];
    wallpaper = [ ",${./assets/bg.png}" ];
    splash = false;
  };
}

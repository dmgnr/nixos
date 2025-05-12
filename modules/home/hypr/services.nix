{ ... }:
{
  services.hyprpolkitagent.enable = true;
  # services.dunst.enable = true;
  services.swaync = {
    enable = true;
    style = ./assets/swaync.css;
    settings = {
      widgets = [
        "inhibitors"
        "title"
        "dnd"
        "notifications"
        "mpris"
        "volume"
      ];
    };
  };
  services.wluma = {
    enable = true;
    settings = {
      als = {
        time = {
          thresholds = {
            "0" = "night";
            "8" = "day";
            "18" = "night";
          };
        };
      };
      output = {
        backlight = [
          {
            name = "eDP-1";
            path = "/sys/class/backlight/intel_backlight";
            capturer = "wayland";
          }
        ];
      };
    };
  };
}

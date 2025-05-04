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
}

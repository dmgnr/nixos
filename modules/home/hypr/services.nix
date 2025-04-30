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
  services.gnome-keyring.enable = true;
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/uri-list" = "thorium-browser.desktop";
    };
  };
}

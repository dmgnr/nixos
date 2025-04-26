{ ... }:
{
  services.hyprpolkitagent.enable = true;
  # services.dunst.enable = true;
  services.swaync = {
    enable = true;
    style = ./assets/swaync.css;
  };
  services.gnome-keyring.enable = true;
}

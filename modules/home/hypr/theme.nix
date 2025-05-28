{ pkgs, ... }:
{
  gtk = {
    enable = true;
    cursorTheme = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
      size = 24;
    };

    theme = {
      name = "Fluent";
      package = (pkgs.fluent-gtk-theme.override { colorVariants = [ "dark" ]; });
    };
  };
  qt = {
    enable = true;
    platformTheme.name = "gtk";
    style = {
      name = "Adwaita-Dark";
      package = pkgs.adwaita-qt;
    };
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      gtk-theme = "Fluent";
      color-scheme = "prefer-dark";
      icon-theme = "Papirus-Dark";
    };
  };
}

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
  qt.style.name = "adwaita-dark";
}

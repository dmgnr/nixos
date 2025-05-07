{ pkgs, ... }:
{
  qt = {
    style = "adwaita-dark";
    enable = true;
    platformTheme = "gnome";
  };

  fonts.packages = with pkgs; [
    nerd-fonts.ubuntu
    nerd-fonts.caskaydia-cove
    nerd-fonts.jetbrains-mono
    font-awesome_6
    jost
    maple-mono.truetype
  ];
}

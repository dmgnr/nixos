{ pkgs, ... }:
{
  qt.enable = true;

  fonts.packages = with pkgs; [
    nerd-fonts.ubuntu
    nerd-fonts.caskaydia-cove
    nerd-fonts.jetbrains-mono
    font-awesome_6
    jost
    maple-mono.truetype
  ];

  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/ayu-dark.yaml";
    image = ../home/hypr/assets/bg.png;
    polarity = "dark";
    targets = {
      plymouth.enable = false;
    };
  };
}

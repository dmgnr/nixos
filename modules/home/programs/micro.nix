{ pkgs, ... }:
{
  programs.micro.enable = true;
  programs.kitty.environment = {
    "EDITOR" = "${pkgs.micro}/bin/micro";
  };
}

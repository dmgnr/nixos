{ lib, ... }:
{
  programs.kitty.enable = true;
  programs.kitty.settings = {
    confirm_os_window_close = 0;
    shell = "nu";
    background_opacity = lib.mkForce 0.7;
  };
}

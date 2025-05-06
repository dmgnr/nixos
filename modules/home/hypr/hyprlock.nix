{ config, ... }:
{
  programs.hyprlock.enable = true;
  programs.hyprlock.settings = {
    "$text_color" = "rgba(FFDAD6FF)";
    "$entry_background_color" = "rgba(41000311)";
    "$entry_border_color" = "rgba(896E6C55)";
    "$entry_color" = "rgba(FFDAD6FF)";
    "$font_family" = "Rubik Light";
    "$font_family_clock" = "Rubik Light";
    "$font_material_symbols" = "Material Symbols Rounded";

    general = {
      immediate_render = true;
      hide_cursor = true;
      ignore_empty_input = true;
    };
    auth = {
      "fingerprint:enabled" = true;
    };
    background = {
      monitor = "";
      color = "rgba(1b6bbfFF)";

      path = "${./assets/bg-blank.jpg}";
      blur_passes = 0;
      contrast = 0.8916;
      brightness = 0.8172;
      vibrancy = 0.1696;
      vibrancy_darkness = 0.0;
      # blur_size = 15
      # blur_passes = 4
    };

    # Time-Hour
    label = [
      {
        monitor = "";
        text = "cmd[update:1000] echo \"<span>$(date +\"%I\")</span>\"";
        color = "rgba(255, 255, 255, 1)";
        font_size = 125;
        font_family = "StretchPro";
        position = "80, 190";
        halign = "center";
        valign = "center";
      }

      # Time-Minute
      {
        monitor = "";
        text = "cmd[update:1000] echo \"<span>$(date +\"%M\")</span>\"";
        color = "rgba(147, 196, 255, 1)";
        font_size = 125;
        font_family = "StretchPro";
        position = "0, 70";
        halign = "center";
        valign = "center";
      }

      # Day-Month-Date
      {
        monitor = "";
        text = "cmd[update:1000] echo -e \"$(date +\"%d %B, %a.\")\"";
        color = "rgba(255, 255, 255, 100)";
        font_size = 22;
        font_family = "Suisse Int'l Mono";
        position = "20, -8";
        halign = "center";
        valign = "center";
      }

      # USER
      {
        monitor = "";
        text = "    $USER";
        color = "rgba(216, 222, 233, 0.80)";
        outline_thickness = 2;
        dots_size = 0.2; # Scale of input-field height, 0.2 - 0.8
        dots_spacing = 0.2; # Scale of dots' absolute size, 0.0 - 1.0
        dots_center = true;
        font_size = 22;
        font_family = "SF Pro Display Bold";
        position = "0, -220";
        halign = "center";
        valign = "center";
      }

      # CURRENT SONG
      {
        monitor = "";
        text = "cmd[update:1000] echo \"$(~/.config/hypr/hyprlock/status.sh)\" ";
        color = "rgba(147, 196, 255, 1)";
        font_size = 18;
        font_family = "JetBrains Mono Nerd, SF Pro Display Bold";
        position = "0, 20";
        halign = "center";
        valign = "bottom";
      }
    ];

    # INPUT FIELD
    input-field = {
      monitor = "";
      size = "300, 60";
      outline_thickness = 2;
      dots_size = 0.2; # Scale of input-field height, 0.2 - 0.8
      dots_spacing = 0.2; # Scale of dots' absolute size, 0.0 - 1.0
      dots_center = true;
      outer_color = "rgba(0, 0, 0, 0)";
      inner_color = "rgba(255, 255, 255, 0.1)";
      font_color = "rgb(200, 200, 200)";
      fade_on_empty = false;
      font_family = "SF Pro Display Bold";
      placeholder_text = "<i><span foreground=\"##ffffff99\">🔒 Enter Pass</span></i>";
      hide_input = false;
      position = "0, -290";
      halign = "center";
      valign = "center";
    };
  };

  home.file."${config.xdg.configHome}/hypr/hyprlock/status.sh" = {
    executable = true;
    text = ''
      #!/bin/bash

      song_info=$(playerctl metadata --format '{{title}}      {{artist}}')

      echo "$song_info"
    '';
  };
}

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
    background = {
      monitor = "";
      color = "rgba(16336fFF)";

      path = "${./assets/bg-blank.jpg}";
      blur_passes = 0;
      contrast = 0.8916;
      brightness = 0.8172;
      vibrancy = 0.1696;
      vibrancy_darkness = 0.0;
      # blur_size = 15
      # blur_passes = 4
    };

    # INPUT FIELD
    input-field = {
      monitor = "";
      size = "230, 50";
      outline_thickness = 4;
      dots_size = 0.2; # Scale of input-field height, 0.2 - 0.8
      dots_spacing = 0.2; # Scale of dots' absolute size, 0.0 - 1.0
      dots_center = true;
      outer_color = "rgba(22222299)";
      fail_color = "rgba(22222299)";
      inner_color = "rgba(255, 255, 255, 0.8)";
      font_color = "rgb(34, 34, 34)";
      fade_on_empty = true;
      font_family = "JetBrainsMono Nerd Font Mono";
      placeholder_text = "<i><span foreground=\"##222222\">Input Password...</span></i>";
      hide_input = false;
      position = "0, -220";
      halign = "center";
      valign = "center";
      zindex = 10;
    };

    # CLOCK/TIME
    label = [
      {
        monitor = "";
        text = "\$TIME";
        color = "rgba(255, 255, 255, 1)";
        font_size = 90;
        shadow_passes = 3;
        shadow_boost = 0.5;
        font_family = "JetBrains Mono Nerd Font Mono ExtraBold";
        position = "0, -100";
        halign = "center";
        valign = "top";
        zindex = 3;
      }

      # Battery Status
      {
        monitor = "";
        text = "cmd[update:5000] ${./assets/blazinscripts.sh} -bat";
        shadow_passes = 1;
        shadow_boost = 0.5;
        color = "rgba(222222FF)";
        font_size = 14;
        font_family = "Maple Mono";
        position = "-21, 18";
        halign = "right";
        valign = "bottom";
        zindex = 2;
      }

      # Current Session Status
      {
        monitor = "";
        text = "cmd[update:0:1] echo \"Session : $XDG_SESSION_DESKTOP\"";
        #    shadow_passes = 1
        #    shadow_boost = 0.5
        color = "rgba(222222FF)";
        font_size = 12;
        font_family = "Jost Medium ";
        position = "0, 20";
        halign = "center";
        valign = "bottom";
        zindex = 2;
      }

      # Username
      {
        monitor = "";
        text = "$USER";
        shadow_passes = 1;
        shadow_boost = 0.5;
        color = "rgba(FFFFFFFF)";
        font_size = 14;
        font_family = "Jost Bold Italic ";
        position = "120, 28";
        halign = "left";
        valign = "bottom";
        zindex = 2;
      }

      # Hostname
      {
        monitor = "";
        text = "cmd[update:0:1] echo \"@$(uname -n)\"";
        shadow_passes = 1;
        shadow_boost = 0.5;
        color = "rgba(FFFFFFBB)";
        font_size = 14;
        font_family = "Jost Bold Italic ";
        position = "120, 5";
        halign = "left";
        valign = "bottom";
        zindex = 2;
      }

      # Lock Icon
      {
        monitor = "";
        text = "";
        shadow_passes = 1;
        shadow_boost = 0.5;
        color = "rgba(255, 255, 255, 1)";
        font_size = 20;
        font_family = "Font Awesome 6 Free Solid";
        position = "0, -65";
        halign = "center";
        valign = "top";
        zindex = 2;
      }

      # PLAYER TITLE
      {
        monitor = "";
        text = "cmd[update:1000] echo \"\$(${./assets/blazinscripts.sh} -music --title)\"";
        color = "rgba(255, 255, 255, 0.8)";
        font_size = 14;
        font_family = "JetBrains Mono Nerd Font Mono ExtraBold";
        position = "45, -6";
        halign = "center";
        valign = "center";
        zindex = 1;
      }

      # PLAYER STATUS
      {
        monitor = "";
        text = "cmd[update:1000] echo \"\$(${./assets/blazinscripts.sh} -music --status)\"";
        color = "rgba(255, 255, 255, 1)";
        font_size = 18;
        font_family = "JetBrains Mono Nerd Font Mono Bold";
        position = "-50, -8";
        halign = "center";
        valign = "center";
        zindex = 1;
      }

      # PLAYER SOURCE
      {
        monitor = "";
        text = "cmd[update:1000] echo \"\$(${./assets/blazinscripts.sh} -music --source)\"";
        color = "rgba(255, 255, 255, 0.6)";
        font_size = 10;
        font_family = "JetBrains Mono Nerd Font Mono ";
        position = "-20, 16";
        halign = "center";
        valign = "center";
        zindex = 1;
      }

      # PLAYER Artist
      {
        monitor = "";
        text = "cmd[update:1000] echo \"\$(${./assets/blazinscripts.sh} -music --artist)\"";
        color = "rgba(255, 255, 255, 0.8)";
        font_size = 12;
        font_family = "JetBrains Mono Nerd Font Mono";
        position = "10, -23";
        halign = "center";
        valign = "center";
        zindex = 1;
      }
    ];

    # Big Rectangle
    shape = [
      {
        monitor = "";
        size = "100%, 60";
        color = "rgba(222222AA)";
        halign = "center";
        valign = "bottom";
        zindex = 0;
      }

      # Small Rectangle for Battery
      {
        monitor = "";
        size = "70, 32";
        rounding = 12;
        color = "rgba(FFFFFFFF)";
        halign = "right";
        valign = "bottom";
        position = "-14, 14";
        zindex = 1;
      }

      # Small Rectangle for Session
      {
        monitor = "";
        size = "150, 32";
        rounding = 10;
        color = "rgba(FFFFFFFF)";
        halign = "center";
        valign = "bottom";
        position = "0, 14";
        zindex = 1;
      }

      # PLAYER BOX
      {
        monitor = "";
        color = "rgba(222222BB)";
        size = "300, 84";
        rounding = 10; # negative values mean circle
        position = "0, 0";
        halign = "center";
        valign = "center";
        zindex = 0;
      }
    ];
    # PLAYER IMAGE
    image = [
      {
        monitor = "";
        path = "${./assets/music.webp}";
        size = 60; # lesser side if not 1:1 ratio
        rounding = 5; # negative values mean circle
        border_size = 0;
        rotate = 0; # degrees, counter-clockwise
        reload_time = 2;
        reload_cmd = "${./assets/blazinscripts.sh} -music --arturl";
        position = "-106, 0";
        halign = "center";
        valign = "center";
        zindex = 1;
      }

      # PFP Image
      {
        monitor = "";
        path = "${./assets/me.jpg}";
        size = 100;
        rounding = -1;
        border_size = 3;
        border_color = "rgba(FFFFFFFF)";
        position = "10, 10";
        halign = "left";
        valign = "bottom";
        zindex = 3;
      }
    ];
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

{ config, ... }:
{
  programs.waybar.enable = true;
  programs.waybar.settings = [
    rec {
      layer = "top"; # Waybar at top layer
      "position" = "bottom"; # Waybar at the bottom of your screen
      "reload_style_on_change" = true;
      height = 18; # Waybar height
      # width = 1366; // Waybar width
      # Choose the order of the modules
      modules-left = [
        "hyprland/workspaces"
        "hyprland/window"
      ];
      modules-center = [ ];
      modules-right = [
        "mpris"
        "group/group-info"
        "tray"
        "clock"
      ];
      "hyprland/window" = {
        format = "{}";
        icon = true;
        icon-size = height;
        rewrite = {
          "(.*) - Thorium" = "$1";
          "(.*?) (?:- .* )?- Visual Studio Code" = "$1";
          "• Discord \| (.*)" = "$1";
        };
      };
      "hyprland/workspaces" = {
        format = "{icon}";
        format-icons = {
          active = "|";
          default = "|";
          empty = "|";
        };
        persistent-workspaces = {
          "*" = [
            1
            2
            3
            4
            5
          ];
        };
      };
      tray = {
        # icon-size = 21;
        "spacing" = 5;
      };
      clock = {
        format-alt = "{:%Y-%m-%d}";
      };
      cpu = {
        format = "{usage}%  ";
      };
      memory = {
        format = "{}%  ";
      };
      battery = {
        bat = "BAT0";
        states = {
          full = 100;
          good = 95;
          warning = 30;
          critical = 15;
        };
        format = "{capacity}% {icon}";
        format-full = "{icon}";
        format-good = "{capacity}% {icon}"; # An empty format will hide the module
        format-icons = [
          "󰁻"
          "󰁼"
          "󰁾"
          "󰂀"
          "󰂂"
          "󰁹"
        ];
      };
      "network" = {
        format-wifi = " ";
        format-ethernet = "";
        format-disconnected = "";
        tooltip-format-disconnected = "Not connected.";
        tooltip-format-wifi = "{essid} ({signalStrength}%) ";
        tooltip-format-ethernet = "{ifname} 🖧 ";
        on-click = "kitty nmtui";
      };
      "pulseaudio" = {
        #scroll-step = 1;
        format = "{volume}% {icon} ";
        format-bluetooth = "{volume}%  ";
        format-muted = "";
        format-icons = {
          headphones = "";
          handsfree = "";
          headset = "";
          phone = "";
          portable = "";
          car = "";
          default = [
            ""
            ""
          ];
        };
        on-click = "pavucontrol";
      };
      "custom/spotify" = {
        format = "{}  ";
        max-length = 20;
        interval = 30; # Remove this if your script is endless and write in loop
        exec = "$HOME/.config/waybar/mediaplayer.sh 2> /dev/null"; # Script in resources folder
        hide-empty-text = true;
        on-click = "playerctl play-pause";
      };
      "custom/info" = {
        exec = "bun ${builtins.toString ./info/index.ts}";
        restart-interval = 5;
        return-type = "json";
      };
      mpris = {
        format = "{dynamic} {player_icon}";
        format-paused = "<i>{dynamic}</i> {status_icon}";
        dynamic-len = 30;
        player-icons = {
          default = "";
          mpv = "󰎆";
        };
        status-icons = {
          paused = "";
        };
      };
      "group/group-info" = {
        drawer = {
          transition-duration = 500;
          transition-left-to-right = false;
        };
        modules = [
          "custom/info"
          "pulseaudio"
          "network"
          "cpu"
          "memory"
          "battery"
        ];
        orientation = "inherit";
      };
    }
  ];
  programs.waybar.style = builtins.readFile ./assets/waybar.css;
  home.file."${config.xdg.configHome}/waybar/mediaplayer.sh" = {
    executable = true;
    text = ''
          #!/bin/sh
      player_status=$(playerctl status 2> /dev/null)
      if [ "$player_status" = "Playing" ]; then
          echo "$(playerctl metadata artist)"
      elif [ "$player_status" = "Paused" ]; then
          echo " $(playerctl metadata artist)"
      fi
    '';
  };
}

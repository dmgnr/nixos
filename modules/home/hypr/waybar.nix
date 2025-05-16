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
        actions = {
          on-click-right = "mode";
          on-scroll-down = "shift_down";
          on-scroll-up = "shift_up";
        };
        calendar = {
          format = {
            days = "<span color='#ecc6d9'><b>{}</b></span>";
            months = "<span color='#ffead3'><b>{}</b></span>";
            today = "<span color='#ff6699'><b><u>{}</u></b></span>";
            weekdays = "<span color='#ffcc66'><b>{}</b></span>";
            weeks = "<span color='#99ffdd'><b>W{}</b></span>";
          };
          mode = "year";
          mode-mon-col = 3;
          on-scroll = 1;
          weeks-pos = "right";
        };
        tooltip-format = "<tt><small>{calendar}</small></tt>";
      };
      cpu = {
        format = "{usage}%  ";
        on-click = "hyprctl dispatch exec \"[float; size 90% 90%; pin; stayfocused]kitty btop\"";
      };
      memory = {
        format = "{}%  ";
        on-click = cpu.on-click;
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
        on-click = "hyprctl dispatch exec \"[float; size 350 400; move 100%-350 100%-418; pin; stayfocused]kitty nmtui\"";
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
        on-click = "hyprctl dispatch exec \"[float; size 380 400; move 100%-400 100%-418; pin; stayfocused]pavucontrol\"";
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
        exec = "bun ${./info/index.ts}";
        restart-interval = 5;
        return-type = "json";
        on-click = "swaync-client -t";
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
          "tray"
        ];
        orientation = "inherit";
      };
    }
  ];
  programs.waybar.systemd.enable = true;
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

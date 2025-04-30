{ ... }:
{
  imports = [
    ./tofi.nix
    ./waybar.nix
    ./hyprpaper.nix
    ./services.nix
    ./hypridle.nix
    ./hyprlock.nix
    ./theme.nix
  ];

  wayland.windowManager.hyprland.enable = true;
  wayland.windowManager.hyprland.systemd.extraCommands = [
    "hyprctl setcursor Bibata-Modern-Classic 24"
    "systemctl --user start hyprpolkitagent hypridle hyprpaper swaync gnome-keyring"
    "hyprlock & waybar & kitty & kdeconnectd & kdeconnect-indicator"
  ];
  wayland.windowManager.hyprland.settings = {
    "$mod" = "SUPER";
    "$terminal" = "kitty nu";
    "$fileManager" = "dolphin";
    "$menud" = "tofi-drun";
    "$menu" = "$(tofi-run --require-match=false)";
    "$util" = "bun ${./util/index.ts}";
    "$browser" = "thorium-avx";

    monitor = ",preferred,auto,auto";

    # General settings
    general = {
      gaps_in = 2;
      gaps_out = 1;
      border_size = 2;
      "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
      "col.inactive_border" = "rgba(595959aa)";
      resize_on_border = false;
      allow_tearing = false;
      layout = "dwindle";
    };

    # Decoration settings
    decoration = {
      rounding = 1;
      rounding_power = 2;
      active_opacity = 1.0;
      inactive_opacity = 1.0;
      shadow = {
        enabled = true;
        range = 4;
        render_power = 3;
        color = "rgba(1a1a1aee)";
      };
      blur = {
        enabled = true;
        size = 3;
        passes = 2;
        vibrancy = 0.1696;
      };
    };

    # Animation settings
    animations = {
      enabled = true;
      bezier = [
        "easeOutQuint,0.23,1,0.32,1"
        "easeInOutCubic,0.65,0.05,0.36,1"
        "linear,0,0,1,1"
        "almostLinear,0.5,0.5,0.75,1.0"
        "quick,0.15,0,0.1,1"
      ];
      animation = [
        "global, 1, 10, default"
        "border, 1, 5.39, easeOutQuint"
        "windows, 1, 4.79, easeOutQuint"
        "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
        "windowsOut, 1, 1.49, linear, popin 87%"
        "fadeIn, 1, 1.73, almostLinear"
        "fadeOut, 1, 1.46, almostLinear"
        "fade, 1, 3.03, quick"
        "layers, 1, 3.81, easeOutQuint"
        "layersIn, 1, 4, easeOutQuint, fade"
        "layersOut, 1, 1.5, linear, fade"
        "fadeLayersIn, 1, 1.79, almostLinear"
        "fadeLayersOut, 1, 1.39, almostLinear"
        "workspaces, 1, 1.94, almostLinear, fade"
        "workspacesIn, 1, 1.21, almostLinear, fade"
        "workspacesOut, 1, 1.94, almostLinear, fade"
      ];
    };

    # Miscellaneous settings
    misc = {
      force_default_wallpaper = -1;
      disable_hyprland_logo = true;
    };

    # Input settings
    input = {
      kb_layout = "us,th";
      kb_options = "grp:win_space_toggle";
      follow_mouse = 1;
      sensitivity = 0;
      touchpad = {
        natural_scroll = false;
      };
    };

    # Gestures
    gestures = {
      workspace_swipe = false;
    };

    # Device-specific settings
    device = {
      name = "epic-mouse-v1";
      sensitivity = -0.5;
    };

    # Keybindings
    bind =
      [
        "$mod, Q, exec, $terminal"
        "$mod, L, exec, hyprlock"
        "ALT, F4, killactive,"
        "ALT SHIFT, F4, forcekillactive,"
        "$mod, E, exec, $fileManager"
        "$mod, V, togglefloating,"
        "$mod, R, exec, $menud"
        "$mod SHIFT, R, exec, $menu"
        "$mod, F, exec, $util"
        "$mod, T, exec, $browser"
        "$mod, P, pseudo,"
        "$mod, J, togglesplit,"
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"
        "$mod, G, togglegroup," # Toggle group on active window
        "$mod, TAB, changegroupactive," # Move into group
        # ...additional keybindings from hyprland.conf...
      ]
      ++ (
        # workspaces
        # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
        builtins.concatLists (
          builtins.genList (
            i:
            let
              ws = i + 1;
            in
            [
              "$mod, code:1${toString i}, workspace, ${toString ws}"
              "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
            ]
          ) 9
        )
      );
    bindm = [
      # Move/resize windows with mainMod + LMB/RMB and dragging
      "$mod, mouse:272, movewindow"
      "$mod, mouse:273, resizewindow"
    ];
    bindel = [
      # Laptop multimedia keys for volume and LCD brightness
      ",XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
      ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
      ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
      ",XF86MonBrightnessUp, exec, brightnessctl s 10%+;hyprctl notify 1 2000 0 \"Brightness increased\""
      ",XF86MonBrightnessDown, exec, brightnessctl s 10%-;hyprctl notify 1 2000 0 \"Brightness reduced\""
    ];
    bindl = [
      # Requires playerctl
      ", XF86AudioNext, exec, playerctl next"
      ", XF86AudioPause, exec, playerctl play-pause"
      ", XF86AudioPlay, exec, playerctl play-pause"
      ", XF86AudioPrev, exec, playerctl previous"
      # Screenshot
      ", print, exec, hyprshot -m region --clipboard-only -z -s"
      "SHIFT, print, exec, hyprshot -m output -m active --clipboard-only -s"
    ];
    windowrulev2 = [
      # Ignore maximize requests from apps. You'll probably like this.
      "suppressevent maximize, class:.*"
      # Fix some dragging issues with XWayland
      "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
      # Keep picture in picture on all workspaces
      "float, title:^(Picture in picture)$"
      "pin, title:^(Picture in picture)$"
      "noborder, onworkspace:w[tv1] f[-1], floating:0"
    ];

    # Waybar blur
    layerrule = [
      "blur, waybar"
      "blur, wofi"
    ];

    env = [
      # Set the environment variable to use the correct theme
      "HYPRCURSOR_THEME,Bibata-Modern-Classic"
      "__NV_PRIME_RENDER_OFFLOAD,1"
    ];
  };
}

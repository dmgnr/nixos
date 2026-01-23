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
    # boot.ts initialize all necessary services at startup
    "hyprlock & kitty & bun ${./util/boot.ts}"
  ];
  wayland.windowManager.hyprland.settings = {
    "$mod" = "SUPER";
    "$terminal" = "kitty nu";
    "$fileManager" = "dolphin";
    "$menud" = "tofi-drun";
    "$menu" = ''hyprctl dispatch exec "[float; size monitor_w 20; move 0 monitor_h-43; pin; stayfocused; animation slide bottom; noborder]LAUNCHER=1 kitty --class launcher nu"'';
    "$util" = "bun ${./util/index.ts}";
    "$browser" = "thorium";
    "$qalc" =
      "pkill qalc; hyprctl dispatch exec \"[size 350 400; move monitor_w-350 monitor_h-420; pin; float; stay_focused; dim_around; animation slide bottom]kitty qalc\"";
    "$record" =
      "bash -c 'pkill wf-recorder || (hyprctl notify 1 2000 0 \"Recording started\" && wf-recorder -f recording.mp4 -y -g \"$(slurp)\" && wl-copy -t video/mp4 < recording.mp4 && hyprctl notify 1 2000 0 \"Recording finished\")'";
    "$recordfull" =
      "bash -c 'pkill wf-recorder || (hyprctl notify 1 2000 0 \"Recording started\" && wf-recorder -f recording.mp4 -y && wl-copy -t video/mp4 < recording.mp4 && hyprctl notify 1 2000 0 \"Recording finished\")'";
    "$togglewb" =
      "pkill -SIGUSR1 waybar";
    "$caelestia" = ''bash -c "systemctl kill --user --fail caelestia && systemctl --user start waybar swaync || (systemctl --user stop waybar swaync && systemctl --user start caelestia)"'';
    "$clauncher" = "caelestia shell drawers toggle launcher";

    monitorv2 = {
      output = "eDP-1";
      mode = "1920x1080@60";
      position = "0x0";
      scale = 1;
      bitdepth = 10;
      #cm = wide
    };
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

    xwayland = {
      create_abstract_socket = true;
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
      disable_splash_rendering = true;
      enable_swallow = true;
      swallow_regex = [ "kitty" ];
      focus_on_activate = true;
    };

    # Input settings
    input = {
      kb_layout = "us,th";
      kb_options = "caps:none,grp:win_space_toggle";
      follow_mouse = 1;
      sensitivity = 0;
      touchpad = {
        natural_scroll = false;
      };
    };

    # Device-specific settings
    device = {
      name = "epic-mouse-v1";
      sensitivity = -0.5;
    };

    ecosystem = {
      no_update_news = true;
      no_donation_nag = true;
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
        "$mod, P, pin,"
        "$mod, J, togglesplit,"
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"
        "$mod, G, togglegroup," # Toggle group on active window
        "$mod, TAB, changegroupactive," # Move into group
        "$mod, C, exec, $qalc"
        "$mod, H, exec, $togglewb"
        "$mod SHIFT, S, exec, $caelestia"
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
    bindr = [
      # "$mod, SUPER_L, exec, $clauncher"
      "$mod SHIFT, 201, exec, $clauncher"
    ];
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
      ",XF86MonBrightnessUp, exec, brightnessctl s 2%+;hyprctl notify 1 2000 0 \"Brightness increased\""
      ",XF86MonBrightnessDown, exec, brightnessctl s 2%-;hyprctl notify 1 2000 0 \"Brightness reduced\""
    ];
    bindl = [
      # Requires playerctl
      ", XF86AudioNext, exec, playerctl next"
      ", XF86AudioPause, exec, playerctl play-pause"
      ", XF86AudioPlay, exec, playerctl play-pause"
      ", XF86AudioPrev, exec, playerctl previous"
      "$mod SHIFT, 201 right, exec, playerctl next"
      "$mod SHIFT, 201 down, exec, playerctl play-pause"
      # Screenshot
      ", print, exec, hyprshot -m region --clipboard-only -z -s"
      "SHIFT, print, exec, hyprshot -m output -m active --clipboard-only -s"
      "ALT, print, exec, $record"
      "ALT SHIFT, print, exec, $recordfull"
    ];
    windowrule = [
      # Ignore maximize requests from apps. You'll probably like this.
      "suppress_event maximize, match:class .*"
      # Keep picture in picture on all workspaces
      "float on, pin on, match:title ^(Picture in picture)$"
      # Remove border when there's only 1 window
      "border_size 0, match:workspace w[tv1] f[-1], match:float 0"
      # Fix some issues with Waydroid
      "float on, maximize on, pin on, no_blur on, match:class ^(waydroid\.)(.+)$"
      # Fix buggy scaling in Wine
      "float on, match:class ^(.+)\.exe$"
      # Float file dialog
      "float on, match:title ^Open (File|Folder)$"
      # Fix context menu blur
      "no_blur on, match:class ^()$, match:title ^()$"
    ];

    # Waybar blur
    layerrule = [
      {
        name = "layerrule-1";
        blur = "on";
        "match:namespace" = "waybar";
      }
      {
        name = "layerrule-2";
        blur = "on";
        "match:namespace" = "wofi";
      }
    ];

    env = [
      # Set the environment variable to use the correct theme
      "HYPRCURSOR_THEME,Bibata-Modern-Classic"
      "__NV_PRIME_RENDER_OFFLOAD,1"
      "XDG_CURRENT_DESKTOP,Hyprland"
    ];

    "plugin.hyprwinwrap.class" = "bg";
  };
}

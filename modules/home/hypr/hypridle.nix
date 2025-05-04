{ ... }:
{
  services.hypridle.enable = true;
  services.hypridle.settings = {
    "$lock_cmd" = "pidof hyprlock || hyprlock";
    "$suspend_cmd" = "pidof steam || systemctl suspend || loginctl suspend"; # fuck nvidia

    general = {
      lock_cmd = "$lock_cmd";
      before_sleep_cmd = "loginctl lock-session";
    };

    listener = [
      {
        timeout = 300; # 5mins
        on-timeout = "brightnessctl -s s 10%";
        on-resume = "brightnessctl -r";
      }

      {
        timeout = 360; # 6mins
        on-timeout = "loginctl lock-session";
      }

      {
        timeout = 900; # 15mins
        on-timeout = "hyprctl dispatch dpms off";
        on-resume = "hyprctl dispatch dpms on";
      }

      {
        timeout = 1800; # 30mins
        on-timeout = "$suspend_cmd";
      }
    ];
  };
}

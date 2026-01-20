{
  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
    wireplumber.enable = true;
    wireplumber.extraConfig."99-stop-microphone-auto-adjust" = {
      "access.rules" = [
        {
          matches = [ { "application.process.binary" = "electron"; } ];
          actions = {
            update-props = {
              default_permissions = "rx";
            };
          };
        }
      ];
    };
    wireplumber.extraConfig."11-conexant-fix.conf" = {
      "monitor.alsa.rules" = [
        {
          matches = [
            { "device.name" = "~alsa_card.*"; }
          ];

          actions = {
            update-props = {
              # keep soft volume
              "api.alsa.soft-mixer" = true;
              "api.alsa.ignore-dB" = true;
            };

            # run once when card appears
            exec = [
              {
                path = "/run/current-system/sw/bin/amixer";
                args = [
                  "-c"
                  "1"
                  "set"
                  "Speaker"
                  "unmute"
                ];
              }
              {
                path = "`/run/current-system/sw/bin/amixer`";
                args = [
                  "-c"
                  "1"
                  "set"
                  "Line Out"
                  "100%"
                  "unmute"
                ];
              }
              {
                path = "/run/current-system/sw/bin/amixer";
                args = [
                  "-c"
                  "1"
                  "set"
                  "Headphone"
                  "100%"
                  "unmute"
                ];
              }
            ];
          };
        }
      ];
    };

  };
}

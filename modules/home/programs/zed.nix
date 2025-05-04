{
  programs.zed-editor = {
    enable = true;
    extensions = [ "nix" ];
    userSettings = {
      base_keymap = "VSCode";
      buffer_font_size = 16;
      features = {
        edit_prediction_provider = "zed";
      };
      languages = {
        Nix = {
          language_servers = [
            "nixd"
            "!nil"
          ];
        };
      };
      telemetry = {
        diagnostics = false;
        metrics = false;
      };
      theme = {
        dark = "One Dark";
        light = "Catppuccin Macchiato";
        mode = "system";
      };
      ui_font_size = 16;
    };
  };
}

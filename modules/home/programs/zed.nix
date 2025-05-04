{
  programs.zed-editor = {
    enable = true;
    extensions = [
      "nix"
      "java"
      "mcp-server-context7"
      "mcp-server-puppeteer"
      "mcp-server-sequential-thinking"
      "modest-dark"
      "symbols"
    ];
    userSettings = {
      base_keymap = "VSCode";
      buffer_font_size = 12;
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
        dark = "Modest Dark";
        light = "Modest Dark";
        mode = "system";
      };
      icon_theme = {
        mode = "system";
        light = "Symbols";
        dark = "Symbols";
      };
      autosave = {
        after_delay = {
          milliseconds = 100;
        };
      };
      ui_font_size = 14;
    };
  };
}

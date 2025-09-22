{ lib, pkgs, ... }:
{
  programs.zed-editor = {
    enable = false;
    extensions = [
      "nix"
      "java"
      "mcp-server-context7"
      "mcp-server-puppeteer"
      "mcp-server-sequential-thinking"
      "symbols"
    ];
    userSettings = {
      base_keymap = "VSCode";
      buffer_font_size = lib.mkForce 12;
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
      ui_font_size = lib.mkForce 14;
    };
    package = pkgs.zed-editor-fhs;
  };
}

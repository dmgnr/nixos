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
      tab_size = 2;
      agent = {
        default_model = {
          provider = "copilot_chat";
          model = "gpt-5-mini";
        };
        model_parameters = [
        
        ];
      };
      context_servers = {
        mcp-server-context7 = {
          enabled = true;
          settings = {
          };
        };
      };
      active_pane_modifiers = {
        inactive_opacity = 0.8;
      };
      inlay_hints = {
        show_parameter_hints = false;
        show_value_hints = true;
        show_type_hints = true;
        enabled = false;
      };
      diagnostics = {
        inline = {
          enabled = true;
        };
      };
      minimap = {
        thumb = "hover";
        show = "auto";
      };
      edit_predictions = {
        mode = "subtle";
      };
      features = {
        edit_prediction_provider = "zed";
      };
      autosave = "on_focus_change";
      ssh_connections = [
        {
          host = "astral";
          username = "dmgnr";
          args = [
          
          ];
          projects = [
            {
              paths = [
                "/home/dmgnr/cdn"
              ];
            }
            {
              paths = [
                "/srv/buzzy"
              ];
            }
          ];
        }
      ];
      telemetry = {
        diagnostics = false;
        metrics = false;
      };
      icon_theme = {
        mode = "system";
        light = "Zed (Default)";
        dark = "Zed (Default)";
      };
      ui_font_size = lib.mkForce 16;
      buffer_font_size = lib.mkForce 15;
      theme = lib.mkForce {
        mode = "system";
        light = "Ayu Light";
        dark = "Ayu Darker";
      };
      languages = {
        JavaScript = {
          formatter = {
            language_server = {
              name = "biome";
            };
          };
          code_actions_on_format = {
            "source.fixAll.biome" = true;
            "source.organizeImports.biome" = true;
            "source.addMissingImports.ts" = true;
            "source.removeUnusedImports" = true;
          };
        };
        TypeScript = {
          formatter = {
            language_server = {
              name = "biome";
            };
          };
          code_actions_on_format = {
            "source.fixAll.biome" = true;
            "source.organizeImports.biome" = true;
            "source.addMissingImports.ts" = true;
            "source.removeUnusedImports" = true;
          };
        };
        TSX = {
          inlay_hints = {
          };
          formatter = {
            language_server = {
              name = "biome";
            };
          };
          code_actions_on_format = {
            "source.fixAll.biome" = true;
            "source.organizeImports.biome" = true;
            "source.addMissingImports.ts" = true;
            "source.removeUnusedImports" = true;
          };
        };
        JSON = {
          formatter = {
            language_server = {
              name = "biome";
            };
          };
        };
        JSONC = {
          formatter = {
            language_server = {
              name = "biome";
            };
          };
        };
        CSS = {
          formatter = {
            language_server = {
              name = "biome";
            };
          };
        };
      };
      max_tabs = 10;
      auto_install_extensions = {
        html = true;
        ayu-darker = true;
        biome = true;
        dockerfile = true;
        emmet = true;
        mcp-server-context7 = true;
        mcp-server-sequential-thinking = true;
        sql = true;
      };
    };
    # package = pkgs.zed-editor-fhs;
  };
}

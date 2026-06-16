_: {
  colorschemes.cyberdream = {
    enable = true;
    settings = {
      transparent = true;
      italic_comments = true;
      hide_fillchars = false;
      borderless_telescope = true;
      terminal_colors = true;
    };
  };

  plugins = {

    lualine = {
      enable = true;
      settings = {
        options = {
          theme = "cyberdream";
          globalstatus = true;
          component_separators = {
            left = "│";
            right = "│";
          };
          section_separators = {
            left = "";
            right = "";
          };
          disabled_filetypes = {
            statusline = [
              "dashboard"
              "alpha"
              "snacks_dashboard"
            ];
            winbar = [
              "dashboard"
              "alpha"
              "snacks_dashboard"
            ];
          };
        };
        sections = {
          lualine_a = [ "mode" ];
          lualine_b = [
            "branch"
            "diff"
            "diagnostics"
          ];
          lualine_c = [
            {
              __unkeyed.__raw = ''
                function()
                  local name = vim.fn.expand("%:t")
                  if name == "" then
                    return vim.fn.fnamemodify(vim.fn.getcwd(), ":~")
                  end
                  return name
                end
              '';
            }
          ];
          lualine_x = [
            "encoding"
            "fileformat"
            "filetype"
          ];
          lualine_y = [ "progress" ];
          lualine_z = [ "location" ];
        };
        extensions = [
          "neo-tree"
          "toggleterm"
          "trouble"
          "fzf"
        ];
      };
    };

    bufferline = {
      enable = true;
      settings = {
        options = {
          mode = "buffers";
          separator_style = "thin";
          always_show_bufferline = false;
          show_buffer_close_icons = true;
          show_close_icon = false;
          color_icons = true;
          diagnostics = "nvim_lsp";
          offsets = [
            {
              filetype = "neo-tree";
              text = "Explorer";
              highlight = "Directory";
              text_align = "left";
              separator = true;
            }
          ];
        };
      };
    };

    noice = {
      enable = true;
      settings = {
        presets = {
          bottom_search = true;
          command_palette = true;
          long_message_to_split = true;
          inc_rename = true;
          lsp_doc_border = true;
        };
        views = {
          cmdline_popup = {
            position = {
              row = "98%";
              col = "50%";
            };
            size = {
              width = 60;
              height = "auto";
            };
            border = {
              style = "rounded";
              padding = [
                0
                1
              ];
            };
          };
          cmdline_popupmenu = {
            relative = "editor";
            position = {
              row = "98%";
              col = "50%";
            };
            size = {
              width = 60;
              height = 10;
            };
            border = {
              style = "rounded";
              padding = [
                0
                1
              ];
            };
          };
        };
        lsp = {
          override = {
            "vim.lsp.util.convert_input_to_markdown_lines" = true;
            "vim.lsp.util.stylize_markdown" = true;
            "cmp.entry.get_documentation" = true;
          };
          hover.enabled = true;
          signature.enabled = true;
        };
        routes = [
          {
            filter = {
              event = "msg_show";
              kind = "search_count";
            };
            opts.skip = true;
          }
        ];
      };
    };

    notify = {
      enable = true;
      settings = {
        stages = "fade_in_slide_out";
        timeout = 3000;
        max_width = 80;
        render = "compact";
        top_down = true;
      };
    };

    web-devicons.enable = true;

    todo-comments = {
      enable = true;
      settings = {
        signs = true;
        highlight = {
          before = "";
          keyword = "wide_bg";
          after = "fg";
          pattern = ''.*<(KEYWORDS)\s*:'';
          comments_only = true;
          max_line_len = 400;
        };
      };
    };

    dressing = {
      enable = true;
      settings = {
        input = {
          enabled = true;
          default_prompt = "Input:";
          trim_prompt = true;
          border = "rounded";
          relative = "cursor";
        };
        select = {
          enabled = true;
          backend = [
            "telescope"
            "fzf_lua"
            "builtin"
            "nui"
          ];
          builtin.border = "rounded";
        };
      };
    };

    neoscroll = {
      enable = true;
      settings = {
        mappings = [
          "<C-u>"
          "<C-d>"
          "<C-b>"
          "<C-f>"
          "<C-y>"
          "<C-e>"
          "zt"
          "zz"
          "zb"
        ];
        hide_cursor = true;
        stop_eof = true;
        respect_scrolloff = false;
        cursor_scrolls_alone = true;
        easing_function = "quadratic";
      };
    };

    no-neck-pain.enable = true;

    mini-icons = {
      enable = true;
      settings.style = "glyph";
    };

    colorizer = {
      enable = true;
      settings = {
        user_default_options = {
          names = true;
          rgb_fn = true;
          hsl_fn = true;
          css = true;
          css_fn = true;
          mode = "background";
        };
      };
    };
  };

  extraConfigLua = ''
    vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { undercurl = true })
    vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", { undercurl = true })
    vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo", { undercurl = true })
    vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint", { undercurl = true })
  '';
}

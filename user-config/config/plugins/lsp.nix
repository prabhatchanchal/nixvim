{ lib, ... }:
let
  inherit (lib.nixvim) mkRaw;
in
{
  plugins = {
    lsp = {
      enable = true;
      inlayHints = true;
      servers = {
        nixd = {
          enable = true;
          settings = {
            nixpkgs.expr = "import <nixpkgs> { }";
            formatting.command = [ "nixpkgs-fmt" ];
          };
        };

        lua_ls = {
          enable = true;
          settings = {
            Lua = {
              runtime.version = "LuaJIT";
              diagnostics.globals = [ "vim" ];
              workspace = {
                library = mkRaw ''vim.api.nvim_get_runtime_file("", true)'';
                checkThirdParty = false;
              };
              telemetry.enable = false;
            };
          };
        };

        ts_ls.enable = true;
        jsonls.enable = true;
        yamlls.enable = true;
        html.enable = true;
        cssls.enable = true;
        pyright.enable = true;
        ruff.enable = true;
        rust_analyzer = {
          enable = true;
          installCargo = true;
          installRustc = true;
        };
        gopls.enable = true;
        clangd.enable = true;
        bashls.enable = true;
        marksman.enable = true;
        dockerls.enable = true;
        terraformls.enable = true;
        taplo.enable = true;
        typos_lsp = {
          enable = true;
          extraOptions.init_options.diagnosticSeverity = "Hint";
        };
      };

      keymaps = {
        silent = true;
        diagnostic = {
          "<leader>lj" = "goto_next";
          "<leader>lk" = "goto_prev";
        };
        lspBuf = {
          "gd" = "definition";
          "gD" = "declaration";
          "gi" = "implementation";
          "gt" = "type_definition";
          "K" = "hover";
          "<leader>la" = "code_action";
          "<leader>lr" = "rename";
          "<leader>lf" = "format";
          "<leader>ls" = "signature_help";
          "<leader>li" = "incoming_calls";
          "<leader>lo" = "outgoing_calls";
          "<leader>lw" = "workspace_symbol";
        };
      };
    };

    lspsaga = {
      enable = true;
      settings = {
        lightbulb = {
          enable = false;
          virtualText = false;
        };
        symbol_in_winbar.enable = true;
        ui = {
          border = "rounded";
          code_action = "💡";
        };
        finder.keys = {
          vsplit = "v";
          split = "s";
          quit = [
            "q"
            "<Esc>"
          ];
          toggle_or_jump = "p";
          close = "<C-c>";
        };
        outline.keys = {
          jump = "<CR>";
          quit = [
            "q"
            "<Esc>"
          ];
          toggle_or_jump = "o";
        };
        scroll_preview = {
          scroll_down = "<C-d>";
          scroll_up = "<C-u>";
        };
      };
    };

    trouble = {
      enable = true;
      settings = {
        auto_open = false;
        auto_close = false;
        auto_preview = true;
        auto_fold = false;
        use_diagnostic_signs = true;
        icons.indent = {
          middle = "  │ ";
          last = "  └ ";
          top = "  ┌ ";
          ws = "    ";
        };
      };
    };

    nvim-ufo = {
      enable = true;
      settings.provider_selector = mkRaw ''
        function(bufnr, filetype, buftype)
          return { "lsp", "indent" }
        end
      '';
    };

    tiny-inline-diagnostic = {
      enable = true;
      settings = {
        preset = "ghost";
        transparent_bg = false;
      };
    };

    lsp-signature = {
      enable = true;
      settings = {
        bind = true;
        handler_opts.border = "rounded";
        hint_enable = false;
        floating_window = true;
        always_trigger = false;
      };
    };

    conform-nvim = {
      enable = true;
      settings = {
        format_on_save = {
          lsp_fallback = true;
          timeout_ms = 500;
        };
        formatters_by_ft = {
          lua = [ "stylua" ];
          nix = [ "nixpkgs-fmt" ];
          python = [ "ruff_format" ];
          rust = [ "rustfmt" ];
          go = [
            "gofumpt"
            "goimports_reviser"
          ];
          javascript = [
            "prettierd"
            "prettier"
          ];
          typescript = [
            "prettierd"
            "prettier"
          ];
          javascriptreact = [
            "prettierd"
            "prettier"
          ];
          typescriptreact = [
            "prettierd"
            "prettier"
          ];
          json = [
            "prettierd"
            "prettier"
          ];
          yaml = [
            "prettierd"
            "prettier"
          ];
          markdown = [
            "prettierd"
            "prettier"
          ];
          html = [
            "prettierd"
            "prettier"
          ];
          css = [
            "prettierd"
            "prettier"
          ];
          scss = [
            "prettierd"
            "prettier"
          ];
          sh = [ "shfmt" ];
          bash = [ "shfmt" ];
          c = [ "clang_format" ];
          cpp = [ "clang_format" ];
          "_" = [ "trim_whitespace" ];
        };
      };
    };

  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>ld";
      action = "<cmd>Trouble diagnostics toggle<cr>";
      options.desc = "Diagnostics (Trouble)";
    }
    {
      mode = "n";
      key = "<leader>lD";
      action = "<cmd>Trouble diagnostics toggle filter.buf=0<cr>";
      options.desc = "Buffer diagnostics (Trouble)";
    }
    {
      mode = "n";
      key = "<leader>lq";
      action = "<cmd>Trouble qflist toggle<cr>";
      options.desc = "Quickfix (Trouble)";
    }
    {
      mode = "n";
      key = "<leader>lL";
      action = "<cmd>Trouble loclist toggle<cr>";
      options.desc = "Loclist (Trouble)";
    }
    {
      mode = "n";
      key = "<leader>lS";
      action = "<cmd>Trouble symbols toggle<cr>";
      options.desc = "Symbols (Trouble)";
    }
    {
      mode = "n";
      key = "<leader>lR";
      action = "<cmd>Trouble lsp_references toggle<cr>";
      options.desc = "References (Trouble)";
    }
    {
      mode = "n";
      key = "gr";
      action = "<cmd>Lspsaga finder ref<cr>";
      options.desc = "LSP References (floating)";
    }
    {
      mode = "n";
      key = "gd";
      action = "<cmd>Lspsaga goto_definition<cr>";
      options.desc = "Goto definition (floating)";
    }
    {
      mode = "n";
      key = "gD";
      action = "<cmd>Lspsaga finder def<cr>";
      options.desc = "Definition (floating)";
    }
    {
      mode = "n";
      key = "gi";
      action = "<cmd>Lspsaga finder imp<cr>";
      options.desc = "Implementation (floating)";
    }
    {
      mode = "n";
      key = "gt";
      action = "<cmd>Lspsaga finder ty<cr>";
      options.desc = "Type definition (floating)";
    }
    {
      mode = "n";
      key = "<leader>lo";
      action = "<cmd>Lspsaga outline<cr>";
      options.desc = "Outline";
    }
    {
      mode = "n";
      key = "<leader>lp";
      action = "<cmd>Lspsaga peek_definition<cr>";
      options.desc = "Peek definition";
    }
    {
      mode = "n";
      key = "<leader>lP";
      action = "<cmd>Lspsaga peek_type_definition<cr>";
      options.desc = "Peek type definition";
    }
    {
      mode = "n";
      key = "zr";
      action = "<cmd>lua require('ufo').openAllFolds()<cr>";
      options.desc = "Open all folds";
    }
    {
      mode = "n";
      key = "zm";
      action = "<cmd>lua require('ufo').closeAllFolds()<cr>";
      options.desc = "Close all folds";
    }
    {
      mode = "n";
      key = "zR";
      action = "<cmd>lua require('ufo').openAllFolds()<cr>";
      options.desc = "Open all folds";
    }
    {
      mode = "n";
      key = "zM";
      action = "<cmd>lua require('ufo').closeAllFolds()<cr>";
      options.desc = "Close all folds";
    }
    {
      mode = "n";
      key = "zp";
      action = "<cmd>lua require('ufo').peekFoldedLinesUnderCursor()<cr>";
      options.desc = "Peek fold";
    }
  ];
}

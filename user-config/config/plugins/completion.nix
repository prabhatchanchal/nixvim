_: {
  plugins = {
    blink-cmp = {
      enable = true;
      settings = {
        completion = {
          documentation = {
            auto_show = true;
            auto_show_delay_ms = 200;
            window.border = "rounded";
          };
          ghost_text.enabled = true;
          list.selection.preselect = false;
          menu = {
            auto_show = true;
            draw = {
              columns = [
                { __raw = "{ 'label', 'label_description', gap = 1 }"; }
                { __raw = "{ 'kind_icon', 'kind', gap = 1 }"; }
              ];
              treesitter = [ "lsp" ];
            };
            border = "rounded";
          };
          trigger.show_in_snippet = false;
        };
        fuzzy.implementation = "prefer_rust_with_warning";
        keymap = {
          preset = "enter";
          "<C-space>" = [
            "show"
            "show_documentation"
            "hide_documentation"
          ];
          "<C-e>" = [
            "hide"
            "fallback"
          ];
          "<CR>" = [
            "accept"
            "fallback"
          ];
          "<Tab>" = [
            "snippet_forward"
            "select_next"
            "fallback"
          ];
          "<S-Tab>" = [
            "snippet_backward"
            "select_prev"
            "fallback"
          ];
          "<C-p>" = [
            "select_prev"
            "fallback_to_mappings"
          ];
          "<C-n>" = [
            "select_next"
            "fallback_to_mappings"
          ];
          "<C-b>" = [
            "scroll_documentation_up"
            "fallback"
          ];
          "<C-f>" = [
            "scroll_documentation_down"
            "fallback"
          ];
          "<C-k>" = [
            "show_signature"
            "hide_signature"
            "fallback"
          ];
          "<C-l>" = [
            "snippet_forward"
            "fallback"
          ];
          "<C-h>" = [
            "snippet_backward"
            "fallback"
          ];
        };
        signature = {
          enabled = true;
          window.border = "rounded";
        };
        sources = {
          default = [
            "lsp"
            "path"
            "buffer"
            "snippets"
            "omni"
          ];
          providers = {
            lsp.score_offset = 4;
            path = {
              score_offset = 3;
              opts = {
                trailing_slash = false;
                label_trailing_slash = true;
                show_hidden_files_by_default = false;
              };
            };
            buffer.score_offset = 1;
            snippets = {
              score_offset = 2;
              opts = {
                search_paths = null;
                global_snippets = [ "all" ];
                extended_filetypes = null;
                ignored_filetypes = null;
              };
            };
          };
        };
        cmdline = {
          completion.menu.auto_show = true;
          completion.list.selection.preselect = true;
          keymap.preset = "super-tab";
          sources = [
            "path"
            "cmdline"
          ];
        };
        snippets.preset = "luasnip";
      };
    };

    luasnip = {
      enable = true;
      settings = {
        history = true;
        updateevents = "TextChanged,TextChangedI";
        enable_autosnippets = true;
      };
      fromVscode = [ ];
    };

    friendly-snippets.enable = true;
  };
}

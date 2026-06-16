_: {
  plugins = {
    treesitter = {
      enable = true;
      settings = {
        highlight = {
          enable = true;
          additional_vim_regex_highlighting = false;
        };
        indent.enable = true;
        incremental_selection = {
          enable = true;
          keymaps = {
            init_selection = "gnn";
            node_incremental = "grn";
            scope_incremental = "grc";
            node_decremental = "grm";
          };
        };
      };
      nixGrammars = true;
    };

    treesitter-context = {
      enable = true;
      settings = {
        max_lines = 3;
        min_window_height = 10;
        multiline_threshold = 20;
        trim_scope = "outer";
      };
    };

    rainbow-delimiters.enable = true;
  };
}

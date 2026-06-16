{ lib, ... }:
let
  inherit (lib.nixvim) mkRaw;
in
{
  plugins = {
    telescope = {
      enable = true;
      settings = {
        defaults = {
          prompt_prefix = "  ";
          selection_caret = "  ";
          path_display = [ "truncate" ];
          sorting_strategy = "ascending";
          layout_config = {
            horizontal = {
              prompt_position = "top";
              preview_width = 0.55;
              results_width = 0.8;
            };
            vertical.mirror = false;
            width = 0.87;
            height = 0.80;
            preview_cutoff = 120;
          };
          file_ignore_patterns = [
            "node_modules"
            ".git/"
            ".direnv/"
            "target/"
            "dist/"
            "build/"
            "%.lock"
            "%.svg"
            "%.png"
            "%.jpg"
            "%.jpeg"
          ];
          vimgrep_arguments = [
            "rg"
            "-L"
            "--color=never"
            "--no-heading"
            "--with-filename"
            "--line-number"
            "--column"
            "--smart-case"
          ];
          mappings = {
            i = {
              "<C-n>" = mkRaw "require('telescope.actions').cycle_history_next";
              "<C-p>" = mkRaw "require('telescope.actions').cycle_history_prev";
              "<C-j>" = mkRaw "require('telescope.actions').move_selection_next";
              "<C-k>" = mkRaw "require('telescope.actions').move_selection_previous";
              "<C-c>" = mkRaw "require('telescope.actions').close";
              "<Esc>" = mkRaw "require('telescope.actions').close";
              "<CR>" = mkRaw "require('telescope.actions').select_default";
              "<C-x>" = mkRaw "require('telescope.actions').select_horizontal";
              "<C-v>" = mkRaw "require('telescope.actions').select_vertical";
              "<C-u>" = mkRaw "require('telescope.actions').preview_scrolling_up";
              "<C-d>" = mkRaw "require('telescope.actions').preview_scrolling_down";
              "<C-q>" =
                mkRaw "require('telescope.actions').send_to_qflist + require('telescope.actions').open_qflist";
              "<M-q>" =
                mkRaw "require('telescope.actions').send_selected_to_qflist + require('telescope.actions').open_qflist";
              "<C-l>" = mkRaw "require('telescope.actions').complete_tag";
            };
            n = {
              "<Esc>" = mkRaw "require('telescope.actions').close";
              "q" = mkRaw "require('telescope.actions').close";
              "<CR>" = mkRaw "require('telescope.actions').select_default";
              "<C-x>" = mkRaw "require('telescope.actions').select_horizontal";
              "<C-v>" = mkRaw "require('telescope.actions').select_vertical";
              "<Tab>" =
                mkRaw "require('telescope.actions').toggle_selection + require('telescope.actions').move_selection_worse";
              "<S-Tab>" =
                mkRaw "require('telescope.actions').toggle_selection + require('telescope.actions').move_selection_better";
              "<C-q>" =
                mkRaw "require('telescope.actions').send_to_qflist + require('telescope.actions').open_qflist";
              "<M-q>" =
                mkRaw "require('telescope.actions').send_selected_to_qflist + require('telescope.actions').open_qflist";
              "j" = mkRaw "require('telescope.actions').move_selection_next";
              "k" = mkRaw "require('telescope.actions').move_selection_previous";
              "gg" = mkRaw "require('telescope.actions').move_to_top";
              "G" = mkRaw "require('telescope.actions').move_to_bottom";
              "<C-u>" = mkRaw "require('telescope.actions').preview_scrolling_up";
              "<C-d>" = mkRaw "require('telescope.actions').preview_scrolling_down";
            };
          };
        };
        pickers = {
          find_files = {
            hidden = true;
            no_ignore = false;
          };
          live_grep.additional_args = mkRaw ''
            function(opts)
              return { "--hidden" }
            end
          '';
          buffers = {
            sort_lastused = true;
            sort_mru = true;
            ignore_current_buffer = true;
          };
        };
      };
      extensions = {
        fzf-native = {
          enable = true;
          settings = {
            fuzzy = true;
            override_generic_sorter = true;
            override_file_sorter = true;
            case_mode = "smart_case";
          };
        };
        ui-select.enable = true;
      };
    };
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>ff";
      action = "<cmd>Telescope find_files<cr>";
      options.desc = "Find files";
    }
    {
      mode = "n";
      key = "<leader>fF";
      action = "<cmd>Telescope find_files hidden=true no_ignore=true<cr>";
      options.desc = "Find files (all)";
    }
    {
      mode = "n";
      key = "<leader>fr";
      action = "<cmd>Telescope oldfiles<cr>";
      options.desc = "Recent files";
    }
    {
      mode = "n";
      key = "<leader>fg";
      action = "<cmd>Telescope live_grep<cr>";
      options.desc = "Live grep";
    }
    {
      mode = "n";
      key = "<leader>fG";
      action = "<cmd>Telescope live_grep grep_open_files=true<cr>";
      options.desc = "Live grep (open files)";
    }
    {
      mode = "n";
      key = "<leader>fw";
      action = "<cmd>Telescope grep_string<cr>";
      options.desc = "Word grep";
    }
    {
      mode = "n";
      key = "<leader>fb";
      action = "<cmd>Telescope buffers<cr>";
      options.desc = "Buffers";
    }
    {
      mode = "n";
      key = "<leader>fh";
      action = "<cmd>Telescope help_tags<cr>";
      options.desc = "Help tags";
    }
    {
      mode = "n";
      key = "<leader>fk";
      action = "<cmd>Telescope keymaps<cr>";
      options.desc = "Keymaps";
    }
    {
      mode = "n";
      key = "<leader>fc";
      action = "<cmd>Telescope commands<cr>";
      options.desc = "Commands";
    }
    {
      mode = "n";
      key = "<leader>fm";
      action = "<cmd>Telescope marks<cr>";
      options.desc = "Marks";
    }
    {
      mode = "n";
      key = "<leader>fj";
      action = "<cmd>Telescope jumplist<cr>";
      options.desc = "Jumplist";
    }
    {
      mode = "n";
      key = "<leader>ft";
      action = "<cmd>Telescope filetypes<cr>";
      options.desc = "Filetypes";
    }
    {
      mode = "n";
      key = "<leader>fn";
      action = "<cmd>Telescope notify<cr>";
      options.desc = "Notifications";
    }
    {
      mode = "n";
      key = "<leader>f/";
      action = "<cmd>Telescope search_history<cr>";
      options.desc = "Search history";
    }
    {
      mode = "n";
      key = "<leader>f:";
      action = "<cmd>Telescope command_history<cr>";
      options.desc = "Command history";
    }

    {
      mode = "n";
      key = "<leader>gf";
      action = "<cmd>Telescope git_files<cr>";
      options.desc = "Git files";
    }
    {
      mode = "n";
      key = "<leader>gc";
      action = "<cmd>Telescope git_commits<cr>";
      options.desc = "Git commits";
    }
    {
      mode = "n";
      key = "<leader>gC";
      action = "<cmd>Telescope git_bcommits<cr>";
      options.desc = "Buffer commits";
    }
    {
      mode = "n";
      key = "<leader>gs";
      action = "<cmd>Telescope git_status<cr>";
      options.desc = "Git status";
    }
    {
      mode = "n";
      key = "<leader>gt";
      action = "<cmd>Telescope git_stash<cr>";
      options.desc = "Git stash";
    }
    {
      mode = "n";
      key = "<leader>gb";
      action = "<cmd>Telescope git_branches<cr>";
      options.desc = "Git branches";
    }

    {
      mode = "n";
      key = "<leader>ls";
      action = "<cmd>Telescope lsp_document_symbols<cr>";
      options.desc = "Document symbols";
    }
    {
      mode = "n";
      key = "<leader>lS";
      action = "<cmd>Telescope lsp_workspace_symbols<cr>";
      options.desc = "Workspace symbols";
    }
    {
      mode = "n";
      key = "<leader>lr";
      action = "<cmd>Telescope lsp_references<cr>";
      options.desc = "References";
    }
    {
      mode = "n";
      key = "<leader>li";
      action = "<cmd>Telescope lsp_implementations<cr>";
      options.desc = "Implementations";
    }
    {
      mode = "n";
      key = "<leader>ld";
      action = "<cmd>Telescope lsp_definitions<cr>";
      options.desc = "Definitions";
    }
    {
      mode = "n";
      key = "<leader>lt";
      action = "<cmd>Telescope lsp_type_definitions<cr>";
      options.desc = "Type definitions";
    }
    {
      mode = "n";
      key = "<leader>le";
      action = "<cmd>Telescope diagnostics bufnr=0<cr>";
      options.desc = "Buffer diagnostics";
    }
    {
      mode = "n";
      key = "<leader>lE";
      action = "<cmd>Telescope diagnostics<cr>";
      options.desc = "All diagnostics";
    }

    {
      mode = "n";
      key = "<leader>fR";
      action = "<cmd>Telescope resume<cr>";
      options.desc = "Resume last picker";
    }
  ];
}

{ lib, ... }:
let
  inherit (lib.nixvim) mkRaw;
in
{
  plugins.neo-tree = {
    enable = true;
    settings = {
      close_if_last_window = true;
      enable_git_status = true;
      enable_diagnostics = true;
      enable_modified_markers = true;
      enable_refresh_on_write = true;
      sort_case_insensitive = true;

      window = {
        position = "left";
        width = 35;
        mapping_options = {
          noremap = true;
          nowait = true;
        };
      };

      filesystem = {
        follow_current_file = {
          enabled = true;
          leave_dirs_open = false;
        };
        group_empty_dirs = false;
        hijack_netrw_behavior = "open_default";
        use_libuv_file_watcher = true;
        filtered_items = {
          visible = false;
          hide_dotfiles = false;
          hide_gitignored = false;
          hide_hidden = false;
          hide_by_name = [
            "node_modules"
            ".git"
            ".direnv"
            "target"
            "dist"
            "build"
          ];
          never_show = [
            ".DS_Store"
            "thumbs.db"
          ];
        };
        window.mappings = {
          "<bs>" = "navigate_up";
          "." = "set_root";
          "H" = "toggle_hidden";
          "/" = "fuzzy_finder";
          "D" = "fuzzy_finder_directory";
          "f" = "filter_on_submit";
          "<c-x>" = "clear_filter";
          "[g" = "prev_git_modified";
          "]g" = "next_git_modified";
        };
      };

      buffers = {
        follow_current_file = {
          enabled = true;
          leave_dirs_open = false;
        };
        show_unloaded = true;
        window.mappings = {
          "bd" = "buffer_delete";
          "<bs>" = "navigate_up";
          "." = "set_root";
        };
      };

      git_status = {
        window = {
          position = "float";
          mappings = {
            "A" = "git_add_all";
            "gu" = "git_unstage_file";
            "ga" = "git_add_file";
            "gr" = "git_revert_file";
            "gc" = "git_commit";
            "gp" = "git_push";
            "gg" = "git_commit_and_push";
          };
        };
      };

      default_component_configs = {
        container = {
          enable_character_fade = true;
        };
        indent = {
          indent_size = 2;
          padding = 1;
          with_markers = true;
          indent_marker = "│";
          last_indent_marker = "└";
          highlight = "NeoTreeIndentMarker";
          with_expanders = null;
          expander_collapsed = " ";
          expander_expanded = " ";
          expander_highlight = "NeoTreeExpander";
        };
        modified = {
          symbol = "[+";
          highlight = "NeoTreeModified";
        };
        name = {
          trailing_slash = false;
          use_git_status_colors = true;
          highlight = "NeoTreeFileName";
        };
        git_status = {
          symbols = {
            added = "";
            modified = "";
            deleted = "✖";
            renamed = "";
            untracked = "";
            ignored = "◌";
            unstaged = "○";
            staged = "●";
            conflict = "";
          };
        };
        diagnostics = {
          symbols = {
            hint = "󰌵";
            info = " ";
            warn = " ";
            error = " ";
          };
          highlights = {
            hint = "DiagnosticHint";
            info = "DiagnosticInfo";
            warn = "DiagnosticWarn";
            error = "DiagnosticError";
          };
        };
        file_size = {
          enabled = true;
          required_width = 64;
        };
        type = {
          enabled = true;
          required_width = 122;
        };
        last_modified = {
          enabled = true;
          required_width = 88;
        };
        created = {
          enabled = true;
          required_width = 110;
        };
        symlink_target = {
          enabled = false;
        };
      };

      nesting_rules = { };

      commands = { };

      event_handlers = [
        {
          event = "neo_tree_window_after_open";
          handler = mkRaw ''
            function(args)
              -- Auto focus the file tree when it opens
              vim.cmd("wincmd p")
            end
          '';
        }
      ];
    };
  };
}

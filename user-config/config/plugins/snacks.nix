_: {
  plugins = {
    snacks = {
      enable = true;
      settings = {
        bigfile.enabled = true;
        bufdelete.enabled = true;
        dashboard.enabled = false;
        explorer = {
          enabled = true;
          replace_netrw = true;
          sources.explorer.icons = true;
        };
        indent.enabled = true;
        input.enabled = true;
        lazygit.enabled = true;
        notifier = {
          enabled = true;
          timeout = 3000;
          top_down = true;
        };
        picker = {
          enabled = true;
          sources.explorer = {
            hidden = true;
            ignored = true;
            follow = true;
          };
        };
        quickfile.enabled = true;
        rename.enabled = true;
        scope.enabled = true;
        scroll.enabled = false;
        statuscolumn.enabled = true;
        toggle = {
          enabled = true;
          map.__raw = "\"<leader>u\"";
          which_key = true;
          notify = true;
          icon = {
            enabled = " ";
            disabled = " ";
          };
          color = {
            enabled = "green";
            disabled = "yellow";
          };
        };
        words.enabled = true;
        zen = {
          enabled = true;
          toggles = {
            dim = true;
            git_signs = false;
            mini_diff_signs = false;
            diagnostics = true;
            inlay_hints = false;
          };
          show = {
            statusline = true;
            tabline = true;
          };
          win.width = 0;
          zoom = {
            toggles = { };
            show = {
              statusline = true;
              tabline = true;
            };
            win = {
              backdrop = false;
              width = 0;
            };
          };
        };
      };
    };
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>e";
      action = "<cmd>Neotree reveal toggle<cr>";
      options.desc = "File explorer";
    }
    {
      mode = "n";
      key = "<leader>E";
      action = "<cmd>Neotree focus<cr>";
      options.desc = "Focus explorer";
    }
    {
      mode = "n";
      key = "<leader>z";
      action = "<cmd>lua Snacks.zen()<cr>";
      options.desc = "Zen mode";
    }
    {
      mode = "n";
      key = "<leader>Z";
      action = "<cmd>lua Snacks.zen.zoom()<cr>";
      options.desc = "Zoom mode";
    }
    {
      mode = "n";
      key = "<leader>bd";
      action = "<cmd>lua Snacks.bufdelete()<cr>";
      options.desc = "Delete buffer";
    }
    {
      mode = "n";
      key = "<leader>bD";
      action = "<cmd>lua Snacks.bufdelete.other()<cr>";
      options.desc = "Delete other buffers";
    }
    {
      mode = "n";
      key = "<leader>gg";
      action = "<cmd>lua Snacks.lazygit()<cr>";
      options.desc = "LazyGit";
    }
    {
      mode = "n";
      key = "<leader>un";
      action = "<cmd>lua Snacks.notifier.hide()<cr>";
      options.desc = "Dismiss notifications";
    }
    {
      mode = "n";
      key = "<leader>sn";
      action = "<cmd>lua Snacks.notifier.show_history()<cr>";
      options.desc = "Notification history";
    }
    {
      mode = "n";
      key = "<leader>sf";
      action = "<cmd>lua Snacks.picker.files()<cr>";
      options.desc = "Find files (snacks)";
    }
    {
      mode = "n";
      key = "<leader>sg";
      action = "<cmd>lua Snacks.picker.grep()<cr>";
      options.desc = "Live grep (snacks)";
    }
    {
      mode = "n";
      key = "<leader>sr";
      action = "<cmd>lua Snacks.picker.recent()<cr>";
      options.desc = "Recent files (snacks)";
    }
    {
      mode = "n";
      key = "<leader>sb";
      action = "<cmd>lua Snacks.picker.buffers()<cr>";
      options.desc = "Buffers (snacks)";
    }
    {
      mode = "n";
      key = "<leader>sd";
      action = "<cmd>lua Snacks.picker.diagnostics()<cr>";
      options.desc = "Diagnostics (snacks)";
    }
    {
      mode = "n";
      key = "<leader>sD";
      action = "<cmd>lua Snacks.picker.diagnostics_buffer()<cr>";
      options.desc = "Buffer diagnostics (snacks)";
    }
    {
      mode = "n";
      key = "<leader>sk";
      action = "<cmd>lua Snacks.picker.keymaps()<cr>";
      options.desc = "Keymaps (snacks)";
    }
    {
      mode = "n";
      key = "<leader>sh";
      action = "<cmd>lua Snacks.picker.help()<cr>";
      options.desc = "Help (snacks)";
    }
    {
      mode = "n";
      key = "<leader>sm";
      action = "<cmd>lua Snacks.picker.man()<cr>";
      options.desc = "Man pages (snacks)";
    }
    {
      mode = "n";
      key = "<leader>sc";
      action = "<cmd>lua Snacks.picker.colorschemes()<cr>";
      options.desc = "Colorschemes (snacks)";
    }
    {
      mode = "n";
      key = "<leader>sC";
      action = "<cmd>lua Snacks.picker.commands()<cr>";
      options.desc = "Commands (snacks)";
    }
    {
      mode = "n";
      key = "<leader>ss";
      action = "<cmd>lua Snacks.picker.lsp_symbols()<cr>";
      options.desc = "Symbols (snacks)";
    }
    {
      mode = "n";
      key = "<leader>sS";
      action = "<cmd>lua Snacks.picker.lsp_workspace_symbols()<cr>";
      options.desc = "Workspace symbols (snacks)";
    }
    {
      mode = "n";
      key = "<leader>sw";
      action = "<cmd>lua Snacks.picker.grep_word()<cr>";
      options.desc = "Word grep (snacks)";
    }
    {
      mode = "n";
      key = "]]";
      action = "<cmd>lua Snacks.words.jump(vim.v.count1)<cr>";
      options.desc = "Next reference";
    }
    {
      mode = "n";
      key = "[[";
      action = "<cmd>lua Snacks.words.jump(-vim.v.count1)<cr>";
      options.desc = "Prev reference";
    }
  ];
}

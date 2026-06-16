_: {
  plugins.persisted = {
    enable = true;
    enableTelescope = true;
    settings = {
      autostart = true;
      follow_cwd = true;
      use_git_branch = true;
      autoload = true;
      on_autoload_no_session.__raw = ''
        function()
          vim.notify("No session found for " .. vim.fn.getcwd(), vim.log.levels.INFO)
        end
      '';
      allowed_dirs = [ ];
      ignored_dirs = [
        "/tmp"
        "/nix"
        "/nix/store"
        "~/.config"
        "~/.local"
      ];
      telescope = {
        mappings = {
          copy_session = "<C-c>";
          change_branch = "<C-b>";
          delete_session = "<C-d>";
        };
        icons = {
          branch = " ";
          selected = " ";
        };
      };
    };
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>Ss";
      action = "<cmd>SessionSave<cr>";
      options.desc = "Save session";
    }
    {
      mode = "n";
      key = "<leader>Sl";
      action = "<cmd>SessionLoad<cr>";
      options.desc = "Load current session";
    }
    {
      mode = "n";
      key = "<leader>Sd";
      action = "<cmd>SessionDelete<cr>";
      options.desc = "Delete session";
    }
    {
      mode = "n";
      key = "<leader>Sr";
      action = "<cmd>SessionRestore<cr>";
      options.desc = "Restore last session";
    }
    {
      mode = "n";
      key = "<leader>Sf";
      action = "<cmd>Telescope persisted<cr>";
      options.desc = "Find sessions (picker)";
    }
    {
      mode = "n";
      key = "<leader>Sg";
      action = "<cmd>Telescope persisted branch<cr>";
      options.desc = "Find sessions by branch";
    }
  ];

  extraConfigLua = ''
    vim.opt.sessionoptions = "buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
  '';
}

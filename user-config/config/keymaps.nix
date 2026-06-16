_: {
  keymaps = [
    {
      mode = "n";
      key = "<Esc>";
      action = "<cmd>nohlsearch<cr>";
      options.desc = "Clear highlights";
    }
    {
      mode = "n";
      key = "<leader>h";
      action = "<cmd>nohlsearch<cr>";
      options.desc = "Clear highlights";
    }
    {
      mode = "n";
      key = "<leader>w";
      action = "<cmd>w<cr>";
      options.desc = "Save file";
    }
    {
      mode = "n";
      key = "<leader>W";
      action = "<cmd>wa<cr>";
      options.desc = "Save all files";
    }
    {
      mode = "n";
      key = "<leader>q";
      action = "<cmd>q<cr>";
      options.desc = "Quit";
    }
    {
      mode = "n";
      key = "<leader>Q";
      action = "<cmd>q!<cr>";
      options.desc = "Quit without saving";
    }
    {
      mode = "n";
      key = "<leader>qq";
      action = "<cmd>qa<cr>";
      options.desc = "Quit all";
    }
    {
      mode = "n";
      key = "<leader>qQ";
      action = "<cmd>qa!<cr>";
      options.desc = "Quit all (force)";
    }
    {
      mode = "n";
      key = "<leader>qc";
      action.__raw = ''
        function()
          if vim.bo.modified then
            vim.ui.select(
              { "Save and close", "Discard and close", "Cancel" },
              { prompt = "Buffer has unsaved changes:" },
              function(choice)
                if choice == "Save and close" then
                  vim.cmd("write | bdelete")
                elseif choice == "Discard and close" then
                  vim.cmd("bdelete!")
                end
              end
            )
          else
            vim.cmd("bdelete")
          end
        end
      '';
      options.desc = "Close buffer";
    }
    {
      mode = "n";
      key = "<leader>qC";
      action.__raw = ''
        function()
          if not _G._deleted_bufs or #_G._deleted_bufs == 0 then
            vim.notify("No deleted buffer to restore", vim.log.levels.WARN)
            return
          end
          local name = table.remove(_G._deleted_bufs, 1)
          if name and vim.fn.filereadable(name) == 1 then
            vim.cmd("edit " .. vim.fn.fnameescape(name))
          else
            vim.notify("Buffer file no longer exists: " .. (name or "?"), vim.log.levels.WARN)
          end
        end
      '';
      options.desc = "Restore last closed buffer";
    }

    {
      mode = "n";
      key = "<C-h>";
      action = "<C-w>h";
      options.desc = "Go to left window";
    }
    {
      mode = "n";
      key = "<C-j>";
      action = "<C-w>j";
      options.desc = "Go to lower window";
    }
    {
      mode = "n";
      key = "<C-k>";
      action = "<C-w>k";
      options.desc = "Go to upper window";
    }
    {
      mode = "n";
      key = "<C-l>";
      action = "<C-w>l";
      options.desc = "Go to right window";
    }

    {
      mode = "n";
      key = "<leader>sv";
      action = "<cmd>vsplit<cr>";
      options.desc = "Vertical split";
    }
    {
      mode = "n";
      key = "<leader>sh";
      action = "<cmd>split<cr>";
      options.desc = "Horizontal split";
    }
    {
      mode = "n";
      key = "<leader>se";
      action = "<C-w>=";
      options.desc = "Equalize splits";
    }
    {
      mode = "n";
      key = "<leader>sm";
      action = "<cmd>only<cr>";
      options.desc = "Maximize split";
    }

    {
      mode = "n";
      key = "<C-Up>";
      action = "<cmd>resize +2<cr>";
      options.desc = "Increase height";
    }
    {
      mode = "n";
      key = "<C-Down>";
      action = "<cmd>resize -2<cr>";
      options.desc = "Decrease height";
    }
    {
      mode = "n";
      key = "<C-Left>";
      action = "<cmd>vertical resize -2<cr>";
      options.desc = "Decrease width";
    }
    {
      mode = "n";
      key = "<C-Right>";
      action = "<cmd>vertical resize +2<cr>";
      options.desc = "Increase width";
    }

    {
      mode = "n";
      key = "<S-h>";
      action = "<cmd>bprevious<cr>";
      options.desc = "Previous buffer";
    }
    {
      mode = "n";
      key = "<S-l>";
      action = "<cmd>bnext<cr>";
      options.desc = "Next buffer";
    }
    {
      mode = "n";
      key = "[b";
      action = "<cmd>bprevious<cr>";
      options.desc = "Previous buffer";
    }
    {
      mode = "n";
      key = "]b";
      action = "<cmd>bnext<cr>";
      options.desc = "Next buffer";
    }

    {
      mode = "n";
      key = "<leader>tn";
      action = "<cmd>tabnew<cr>";
      options.desc = "New tab";
    }
    {
      mode = "n";
      key = "<leader>tc";
      action = "<cmd>tabclose<cr>";
      options.desc = "Close tab";
    }
    {
      mode = "n";
      key = "<leader>to";
      action = "<cmd>tabonly<cr>";
      options.desc = "Only this tab";
    }
    {
      mode = "n";
      key = "<Tab>";
      action = "<cmd>tabnext<cr>";
      options.desc = "Next tab";
    }
    {
      mode = "n";
      key = "<S-Tab>";
      action = "<cmd>tabprevious<cr>";
      options.desc = "Previous tab";
    }

    {
      mode = "n";
      key = "n";
      action = "nzzzv";
      options.desc = "Next search result";
    }
    {
      mode = "n";
      key = "N";
      action = "Nzzzv";
      options.desc = "Previous search result";
    }

    {
      mode = "n";
      key = "<C-d>";
      action = "<C-d>zz";
      options.desc = "Scroll down half page";
    }
    {
      mode = "n";
      key = "<C-u>";
      action = "<C-u>zz";
      options.desc = "Scroll up half page";
    }
    {
      mode = "n";
      key = "<C-f>";
      action = "<C-f>zz";
      options.desc = "Scroll down full page";
    }
    {
      mode = "n";
      key = "<C-b>";
      action = "<C-b>zz";
      options.desc = "Scroll up full page";
    }

    {
      mode = "v";
      key = "<";
      action = "<gv";
      options.desc = "Decrease indent";
    }
    {
      mode = "v";
      key = ">";
      action = ">gv";
      options.desc = "Increase indent";
    }

    {
      mode = "n";
      key = "<A-j>";
      action = "<cmd>m .+1<cr>==";
      options.desc = "Move line down";
    }
    {
      mode = "n";
      key = "<A-k>";
      action = "<cmd>m .-2<cr>==";
      options.desc = "Move line up";
    }
    {
      mode = "v";
      key = "<A-j>";
      action = ":m '>+1<cr>gv=gv";
      options.desc = "Move selection down";
    }
    {
      mode = "v";
      key = "<A-k>";
      action = ":m '<-2<cr>gv=gv";
      options.desc = "Move selection up";
    }

    {
      mode = "n";
      key = "J";
      action = "mzJ`z";
      options.desc = "Join lines";
    }

    {
      mode = "v";
      key = "p";
      action = ''"_dP'';
      options.desc = "Paste without yank";
    }

    {
      mode = "n";
      key = "x";
      action = ''"_x'';
      options.desc = "Delete char (no yank)";
    }
    {
      mode = "n";
      key = "X";
      action = ''"_X'';
      options.desc = "Delete char back (no yank)";
    }
    {
      mode = "n";
      key = "c";
      action = ''"_c'';
      options.desc = "Change (no yank)";
    }
    {
      mode = "n";
      key = "C";
      action = ''"_C'';
      options.desc = "Change to EOL (no yank)";
    }
    {
      mode = "v";
      key = "x";
      action = ''"_d'';
      options.desc = "Delete (no yank)";
    }
    {
      mode = "v";
      key = "X";
      action = ''"_d'';
      options.desc = "Delete (no yank)";
    }
    {
      mode = "v";
      key = "c";
      action = ''"_c'';
      options.desc = "Change (no yank)";
    }
    {
      mode = "v";
      key = "C";
      action = ''"_c'';
      options.desc = "Change (no yank)";
    }

    {
      mode = "n";
      key = "Q";
      action = "@q";
      options.desc = "Replay macro q";
    }
    {
      mode = "x";
      key = "Q";
      action = ":norm @q<cr>";
      options.desc = "Replay macro q on selection";
    }

    {
      mode = "n";
      key = "<leader>a";
      action = "ggVG";
      options.desc = "Select all";
    }

    {
      mode = "n";
      key = "<leader>cn";
      action = "<cmd>cnext<cr>";
      options.desc = "Next quickfix";
    }
    {
      mode = "n";
      key = "<leader>cp";
      action = "<cmd>cprev<cr>";
      options.desc = "Prev quickfix";
    }
    {
      mode = "n";
      key = "<leader>co";
      action = "<cmd>copen<cr>";
      options.desc = "Open quickfix";
    }
    {
      mode = "n";
      key = "<leader>cc";
      action = "<cmd>cclose<cr>";
      options.desc = "Close quickfix";
    }

    {
      mode = "n";
      key = "<leader>ln";
      action = "<cmd>lnext<cr>";
      options.desc = "Next loclist";
    }
    {
      mode = "n";
      key = "<leader>lp";
      action = "<cmd>lprev<cr>";
      options.desc = "Prev loclist";
    }
    {
      mode = "n";
      key = "<leader>lo";
      action = "<cmd>lopen<cr>";
      options.desc = "Open loclist";
    }
    {
      mode = "n";
      key = "<leader>lc";
      action = "<cmd>lclose<cr>";
      options.desc = "Close loclist";
    }
  ];

  extraConfigLua = ''
    vim.keymap.set('c', '<C-j>', '<C-n>', { noremap = true })
    vim.keymap.set('c', '<C-k>', '<C-p>', { noremap = true })

    -- Terminal mode navigation (to escape terminal and move between windows)
    vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { noremap = true, silent = true })
    vim.keymap.set('t', '<C-h>', '<C-\\><C-n><C-w>h', { noremap = true, silent = true })
    vim.keymap.set('t', '<C-j>', '<C-\\><C-n><C-w>j', { noremap = true, silent = true })
    vim.keymap.set('t', '<C-k>', '<C-\\><C-n><C-w>k', { noremap = true, silent = true })
    vim.keymap.set('t', '<C-l>', '<C-\\><C-n><C-w>l', { noremap = true, silent = true })

    local wk = require('which-key')
    wk.add({
      { "<leader>b", group = "Buffer" },
      { "<leader>c", group = "Code / Quickfix" },
      { "<leader>f", group = "Find" },
      { "<leader>g", group = "Git" },
      { "<leader>l", group = "LSP" },
      { "<leader>s", group = "Split / Session" },
      { "<leader>t", group = "Tab / Toggle" },
      { "<leader>u", group = "UI" },
      { "<leader>w", group = "Window" },
    })
  '';
}

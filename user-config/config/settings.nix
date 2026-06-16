{ lib, ... }:
let
  inherit (lib.nixvim) mkRaw;
in
{
  globals = {
    mapleader = " ";
  };

  opts = {
    number = true;
    relativenumber = true;
    numberwidth = 2;

    cursorline = true;
    cursorlineopt = "number";
    signcolumn = "yes";
    colorcolumn = "80";

    tabstop = 2;
    shiftwidth = 2;
    softtabstop = 2;
    expandtab = true;
    smartindent = true;

    wrap = false;
    linebreak = false;

    ignorecase = true;
    smartcase = true;
    hlsearch = true;
    incsearch = true;

    splitbelow = true;
    splitright = true;
    splitkeep = "screen";

    mouse = "a";
    clipboard = "unnamedplus";
    termguicolors = true;

    undofile = true;
    swapfile = false;
    backup = false;
    writebackup = false;

    updatetime = 300;
    timeoutlen = 500;
    scrolloff = 8;
    sidescrolloff = 8;

    cmdheight = 0;
    showmode = false;
    showcmd = false;
    ruler = false;

    laststatus = 3;
    showtabline = 2;

    conceallevel = 2;
    concealcursor = "";
    fillchars = {
      eob = " ";
    };

    list = true;
    listchars = "space:·,tab:» ,trail:·,extends:⟩,precedes:⟨";

    virtualedit = "block";
    winminwidth = 5;
    smoothscroll = true;
    autoread = true;
    autowrite = true;
    fileencoding = "utf-8";

    pumblend = 0;
    pumheight = 10;
    completeopt = "menu,menuone,noselect";

    foldcolumn = "1";
    foldlevel = 99;
    foldlevelstart = 99;
    foldenable = true;

    spell = false;
    spelllang = "en_us";
  };

  diagnostic.settings = {
    virtual_text = false;
    underline = true;
    signs = true;
    severity_sort = true;
    float = {
      border = "rounded";
      source = "if_many";
      focusable = false;
    };
  };

  autoCmd = [
    {
      event = [ "TextYankPost" ];
      desc = "Highlight on yank";
      callback = mkRaw ''
        function()
          vim.highlight.on_yank({ higroup = "Visual", timeout = 200 })
        end
      '';
    }
    {
      event = [ "BufReadPost" ];
      desc = "Restore cursor position";
      callback = mkRaw ''
        function()
          local mark = vim.api.nvim_buf_get_mark(0, '"')
          local lcount = vim.api.nvim_buf_line_count(0)
          if mark[1] > 0 and mark[1] <= lcount then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
          end
        end
      '';
    }
    {
      event = [ "FocusGained" ];
      pattern = [ "*" ];
      desc = "Auto-check files on focus";
      callback = mkRaw ''
        function()
          if vim.fn.getcmdwintype() == "" then
            vim.cmd("checktime")
          end
        end
      '';
    }
    {
      event = [ "BufWritePre" ];
      pattern = [ "*" ];
      desc = "Strip trailing whitespace on save";
      callback = mkRaw ''
        function()
          local save_cursor = vim.fn.getpos(".")
          vim.cmd([[%s/\s\+$//e]])
          vim.fn.setpos(".", save_cursor)
        end
      '';
    }
    {
      event = [ "BufDelete" ];
      pattern = [ "*" ];
      desc = "Track deleted buffers for restore";
      callback = mkRaw ''
        function(args)
          if not _G._deleted_bufs then
            _G._deleted_bufs = {}
          end
          local name = vim.api.nvim_buf_get_name(args.buf)
          if name and name ~= "" then
            table.insert(_G._deleted_bufs, 1, name)
            if #_G._deleted_bufs > 10 then
              table.remove(_G._deleted_bufs)
            end
          end
        end
      '';
    }
  ];

  performance = {
    byteCompileLua = {
      enable = true;
      nvimRuntime = true;
      plugins = true;
      luaLib = true;
    };
  };

  luaLoader.enable = true;
}

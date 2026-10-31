{
  programs.nixvim = {
    enable = true;

    globals.mapleader = " ";

    opts = {
      number = true;
      relativenumber = true;
      mouse = "a";
      smartindent = true;
      termguicolors = true;
      scrolloff = 8;
    };

    keymaps = [
      {
        key = "<leader>w";
        action = "<cmd>w<CR>";
        options.silent = true;
      }
      {
        key = "<leader>q";
        action = "<cmd>q<CR>";
        options.silent = true;
      }
    ];

    colorschemes.catppuccin.enable = true;

    plugins = {
      lualine.enable = true;
      gitsigns.enable = true;
      which-key.enable = true;

      telescope = {
        enable = true;
        keymaps = {
          "<leader>ff" = "find_files";
          "<leader>fg" = "live_grep";
        };
      };
    };
  };
}

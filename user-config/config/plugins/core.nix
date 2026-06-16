_: {
  plugins = {
    which-key = {
      enable = true;
      settings = {
        preset = "modern";
        win = {
          no_overlap = false;
          col = -1;
          width = {
            min = 30;
            max = 50;
          };
          border = "rounded";
          padding = [
            1
            2
          ];
          wo.winblend = 0;
        };
      };
    };
    nvim-autopairs.enable = true;
    nvim-surround.enable = true;
    comment.enable = true;

    indent-blankline = {
      enable = true;
      settings = {
        indent.char = "│";
        scope = {
          enabled = true;
          show_start = true;
          show_end = false;
        };
      };
    };

    flash = {
      enable = true;
      settings.modes.char.jump_labels = true;
    };

    better-escape = {
      enable = true;
      settings = {
        mapping = [
          "jk"
          "jj"
        ];
        timeout = 200;
      };
    };
  };
}

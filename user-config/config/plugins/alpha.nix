{ lib, ... }:
let
  inherit (lib.nixvim) mkRaw;
in
{
  plugins.alpha = {
    enable = true;
    settings = {
      layout = [
        {
          type = "padding";
          val = 2;
        }
        {
          type = "text";
          val = [
            ""
            "██████╗ ████████╗██████╗  ██████╗ ██╗  ██╗██╗  ██╗"
            "██╔══██╗╚══██╔══╝╚════██╗██╔═══██╗██║  ██║██║  ██║"
            "██████╔╝   ██║    █████╔╝     ██╔╝███████║███████║"
            "██╔══██╗   ██║   ██╔═══╝     ██╔╝ ╚════██║╚════██║"
            "██████╔╝   ██║   ███████╗   ██╔╝       ██║     ██║"
            "╚═════╝    ╚═╝   ╚══════╝   ╚═╝        ╚═╝     ╚═╝"
            ""
          ];
          opts = {
            position = "center";
            hl = "Type";
          };
        }
        {
          type = "padding";
          val = 2;
        }
        {
          type = "group";
          val = [
            {
              type = "button";
              val = "  New file";
              on_press.__raw = "function() vim.cmd([[ene]]) end";
              opts = {
                shortcut = "e";
                position = "center";
                cursor = 5;
                width = 40;
                align_shortcut = "right";
                hl_shortcut = "Keyword";
              };
            }
            {
              type = "padding";
              val = 1;
            }
            {
              type = "button";
              val = "  Find file";
              on_press.__raw = ''function() require("telescope.builtin").find_files() end'';
              opts = {
                shortcut = "f";
                position = "center";
                cursor = 5;
                width = 40;
                align_shortcut = "right";
                hl_shortcut = "Keyword";
              };
            }
            {
              type = "padding";
              val = 1;
            }
            {
              type = "button";
              val = "  Recent files";
              on_press.__raw = ''function() require("telescope.builtin").oldfiles() end'';
              opts = {
                shortcut = "r";
                position = "center";
                cursor = 5;
                width = 40;
                align_shortcut = "right";
                hl_shortcut = "Keyword";
              };
            }
            {
              type = "padding";
              val = 1;
            }
            {
              type = "button";
              val = "  Find text";
              on_press.__raw = ''function() require("telescope.builtin").live_grep() end'';
              opts = {
                shortcut = "g";
                position = "center";
                cursor = 5;
                width = 40;
                align_shortcut = "right";
                hl_shortcut = "Keyword";
              };
            }
            {
              type = "padding";
              val = 1;
            }
            {
              type = "button";
              val = "  Quit";
              on_press.__raw = "function() vim.cmd([[qa]]) end";
              opts = {
                shortcut = "q";
                position = "center";
                cursor = 5;
                width = 40;
                align_shortcut = "right";
                hl_shortcut = "Keyword";
              };
            }
          ];
        }
      ];
      opts = {
        margin = 5;
      };
    };
  };

  # Show alpha when last buffer closes
  autoCmd = [
    {
      event = [ "BufDelete" ];
      desc = "Show alpha when last buffer closes";
      callback = mkRaw ''
        function(args)
          vim.schedule(function()
            local listed = vim.tbl_filter(function(b)
              return vim.api.nvim_buf_is_valid(b)
                and vim.fn.buflisted(b) == 1
                and vim.bo[b].buftype == ""
                and vim.bo[b].filetype ~= "alpha"
                and vim.api.nvim_buf_get_name(b) ~= ""
            end, vim.api.nvim_list_bufs())
            
            if #listed == 0 then
              vim.cmd("Alpha")
            end
          end)
        end
      '';
    }
  ];
}

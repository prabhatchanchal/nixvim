{ pkgs, ... }:
let
  # Fetch git-conflict.nvim directly (nixpkgs marks it unfree incorrectly)
  git-conflict-nvim = pkgs.vimUtils.buildVimPlugin {
    pname = "git-conflict-nvim";
    version = "2025-01-15";
    src = pkgs.fetchFromGitHub {
      owner = "akinsho";
      repo = "git-conflict.nvim";
      rev = "v2.1.0";
      hash = "sha256-1t0kKxTGLuOvuRkoLgkoqMZpF+oKo8+gMsTdgPsSb+8=";
    };
  };

  # When lazygit spawns $EDITOR, this wrapper runs inside lazygit's terminal.
  # It records the target file path, kills lazygit, and exits immediately.
  # Nvim polls for the marker file and opens the file in the parent window.
  lgEditor = pkgs.writeShellScript "lazygit-editor-wrapper" ''
    FILE="$1"
    MARKER="''${LAZYGIT_EDITOR_MARKER}"

    if [ -z "$MARKER" ]; then
      # Marker not set — fallback to plain nvim
      exec nvim "$FILE"
    fi

    # Record which file we want to open
    printf '%s\n' "$FILE" > "$MARKER"

    # Kill lazygit (our parent process)
    PARENT=$(ps -o ppid= -p $$ | tr -d ' ')
    if [ -n "$PARENT" ] && [ "$PARENT" -gt 1 ]; then
      kill "$PARENT" 2>/dev/null
    fi
  '';
in
{
  plugins = {
    gitsigns = {
      enable = true;
      settings = {
        signs = {
          add.text = "▎";
          change.text = "▎";
          delete.text = "_";
          topdelete.text = "‾";
          changedelete.text = "▎";
          untracked.text = "▎";
        };
        signcolumn = true;
        numhl = false;
        linehl = false;
        word_diff = false;
        watch_gitdir.follow_files = true;
        attach_to_untracked = true;
        current_line_blame = false;
        current_line_blame_opts = {
          virt_text = true;
          virt_text_pos = "eol";
          delay = 1000;
          ignore_whitespace = false;
          virt_text_priority = 100;
        };
        sign_priority = 6;
        update_debounce = 100;
        max_file_length = 40000;
        preview_config = {
          border = "rounded";
          style = "minimal";
          relative = "cursor";
          row = 0;
          col = 1;
        };
      };
    };

    lazygit = {
      enable = true;
      settings = {
        floating_window_border_chars = [
          "╭"
          "─"
          "╮"
          "│"
          "╯"
          "─"
          "╰"
          "│"
        ];
        floating_window_scaling_factor = 0.9;
      };
    };

    diffview.enable = true;
  };

  extraPlugins = [
    git-conflict-nvim
  ];

  extraConfigLua = ''
    -- GitConflict setup with co/ct/cb keymaps
    require('git-conflict').setup({
      default_mappings = false,
      default_commands = true,
      disable_diagnostics = false,
      list_opener = 'copen',
      highlights = {
        incoming = 'DiffText',
        current = 'DiffAdd',
      },
    })

    vim.keymap.set('n', 'co', '<Plug>(git-conflict-ours)', { desc = 'Accept ours' })
    vim.keymap.set('n', 'ct', '<Plug>(git-conflict-theirs)', { desc = 'Accept theirs' })
    vim.keymap.set('n', 'cb', '<Plug>(git-conflict-both)', { desc = 'Accept both' })
    vim.keymap.set('n', 'c0', '<Plug>(git-conflict-none)', { desc = 'Accept none' })
    vim.keymap.set('n', ']x', '<Plug>(git-conflict-prev-conflict)', { desc = 'Prev conflict' })
    vim.keymap.set('n', '[x', '<Plug>(git-conflict-next-conflict)', { desc = 'Next conflict' })

    -- Wrap :LazyGit so that pressing 'e' inside lazygit kills lazygit
    -- and opens the file in the parent nvim window.
    vim.api.nvim_create_user_command("LazyGit", function()
      local marker = vim.fn.tempname()
      vim.env.LAZYGIT_EDITOR_MARKER = marker
      vim.env.EDITOR = "${lgEditor}"
      vim.env.VISUAL = "${lgEditor}"

      require("lazygit").lazygit()

      local timer = vim.loop.new_timer()
      timer:start(200, 200, vim.schedule_wrap(function()
        if vim.fn.filereadable(marker) == 0 then
          return
        end

        local lines = vim.fn.readfile(marker)
        vim.fn.delete(marker)
        timer:stop()
        timer:close()

        for _, file in ipairs(lines) do
          if file ~= "" and vim.fn.filereadable(file) == 1 then
            -- Wait a tick so lazygit's floating window has time to close
            vim.defer_fn(function()
              vim.cmd("edit " .. vim.fn.fnameescape(file))
            end, 100)
            break
          end
        end
      end))
    end, {})
  '';

  keymaps = [
    {
      mode = "n";
      key = "<leader>gg";
      action = "<cmd>LazyGit<cr>";
      options.desc = "LazyGit";
    }
    {
      mode = "n";
      key = "<leader>gd";
      action = "<cmd>Gitsigns diffthis<cr>";
      options.desc = "Diff this";
    }
    {
      mode = "n";
      key = "<leader>gD";
      action = "<cmd>DiffviewOpen<cr>";
      options.desc = "Diffview open";
    }
    {
      mode = "n";
      key = "<leader>gh";
      action = "<cmd>Gitsigns preview_hunk<cr>";
      options.desc = "Preview hunk";
    }
    {
      mode = "n";
      key = "<leader>gH";
      action = "<cmd>Gitsigns preview_hunk_inline<cr>";
      options.desc = "Preview hunk inline";
    }
    {
      mode = "n";
      key = "<leader>gb";
      action = "<cmd>Gitsigns blame_line<cr>";
      options.desc = "Blame line";
    }
    {
      mode = "n";
      key = "<leader>gB";
      action = "<cmd>Gitsigns toggle_current_line_blame<cr>";
      options.desc = "Toggle blame";
    }
    {
      mode = "n";
      key = "<leader>gs";
      action = "<cmd>Gitsigns stage_hunk<cr>";
      options.desc = "Stage hunk";
    }
    {
      mode = "n";
      key = "<leader>gS";
      action = "<cmd>Gitsigns undo_stage_hunk<cr>";
      options.desc = "Undo stage hunk";
    }
    {
      mode = "n";
      key = "<leader>gr";
      action = "<cmd>Gitsigns reset_hunk<cr>";
      options.desc = "Reset hunk";
    }
    {
      mode = "n";
      key = "<leader>gR";
      action = "<cmd>Gitsigns reset_buffer<cr>";
      options.desc = "Reset buffer";
    }
    {
      mode = "n";
      key = "]g";
      action = "<cmd>Gitsigns next_hunk<cr>";
      options.desc = "Next hunk";
    }
    {
      mode = "n";
      key = "[g";
      action = "<cmd>Gitsigns prev_hunk<cr>";
      options.desc = "Prev hunk";
    }
  ];
}

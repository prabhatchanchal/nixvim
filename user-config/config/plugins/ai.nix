{ pkgs, ... }:
{
  extraPackages = [ pkgs.sqlite ];

  plugins.avante = {
    enable = true;
    settings = {
      provider = "claude";
      auto_suggestions_provider = "claude";
      behaviour = {
        auto_suggestions = false;
        auto_set_highlight_group = true;
        auto_set_keymaps = true;
        auto_apply_diff_after_generation = false;
        support_paste_from_clipboard = true;
        minimize_diff = true;
      };
      mappings = {
        diff = {
          ours = "co";
          theirs = "ct";
          none = "c0";
          both = "cb";
          next = "]x";
          prev = "[x";
        };
        suggestion = {
          accept = "<M-l>";
          next = "<M-]>";
          prev = "<M-[>";
          dismiss = "<M-]>";
        };
        jump = {
          next = "]]";
          prev = "[[";
        };
        submit = {
          normal = "<CR>";
          insert = "<C-s>";
        };
        sidebar = {
          apply_all = "A";
          apply_cursor = "a";
          switch_windows = "<Tab>";
          reverse_switch_windows = "<S-Tab>";
        };
      };
      hints = {
        enabled = true;
      };
      windows = {
        position = "right";
        wrap = true;
        width = 35;
        sidebar_header = {
          enabled = true;
          align = "center";
          rounded = true;
        };
        input = {
          prefix = " ";
          height = 8;
        };
        edit = {
          border = "rounded";
          start_insert = true;
        };
        ask = {
          floating = false;
          start_insert = true;
          border = "rounded";
        };
      };
      highlights = {
        diff = {
          current = "DiffText";
          incoming = "DiffAdd";
        };
      };
      diff = {
        autojump = true;
        list_opener = "copen";
      };
    };
  };

  extraConfigLua = ''
    -- OpenCode session picker + terminal launcher

    local opencode_buf = nil
    local opencode_win = nil

    function _G.opencode_pick_session()
      -- Query sessions from opencode SQLite DB via python3
      local db_path = vim.fn.expand("~/.local/share/opencode/opencode.db")
      if vim.fn.filereadable(db_path) == 0 then
        vim.notify("OpenCode DB not found at " .. db_path, vim.log.levels.ERROR)
        return
      end

      local tmp_py = vim.fn.tempname() .. ".py"
      vim.fn.writefile({
        "import sqlite3, json, sys",
        "conn = sqlite3.connect(sys.argv[1])",
        "conn.row_factory = sqlite3.Row",
        "cursor = conn.cursor()",
        "cursor.execute('SELECT s.id, s.title, s.directory, s.slug, COALESCE(p.worktree, s.directory) as worktree FROM session s LEFT JOIN project p ON s.project_id = p.id WHERE s.time_archived IS NULL ORDER BY s.time_updated DESC')",
        "rows = []",
        "for r in cursor.fetchall():",
        "    rows.append(dict(r))",
        "print(json.dumps(rows))",
        "conn.close()",
      }, tmp_py)

      local sessions = {}
      local handle = io.popen("python3 " .. vim.fn.shellescape(tmp_py) .. " " .. vim.fn.shellescape(db_path))
      if handle then
        local output = handle:read("*a")
        handle:close()
        vim.fn.delete(tmp_py)
        local ok, data = pcall(vim.json.decode, output)
        if ok and data then
          for _, row in ipairs(data) do
            table.insert(sessions, {
              id = row.id,
              title = row.title and row.title ~= "" and row.title or row.slug,
              dir = row.worktree and row.worktree ~= "" and row.worktree or row.directory,
              slug = row.slug,
            })
          end
        end
      end

      if #sessions == 0 then
        vim.notify("No OpenCode sessions found", vim.log.levels.WARN)
        return
      end

      -- Build telescope picker
      local pickers = require("telescope.pickers")
      local finders = require("telescope.finders")
      local conf = require("telescope.config").values
      local actions = require("telescope.actions")
      local action_state = require("telescope.actions.state")

      pickers.new({
        initial_mode = "normal",
      }, {
        prompt_title = "OpenCode Sessions",
        finder = finders.new_table({
          results = sessions,
          entry_maker = function(entry)
            local display = string.format("%s  %s", entry.title, entry.dir)
            return {
              value = entry,
              display = display,
              ordinal = entry.title .. " " .. entry.dir,
            }
          end,
        }),
        sorter = conf.generic_sorter({}),
        attach_mappings = function(prompt_bufnr, map)
          actions.select_default:replace(function()
            actions.close(prompt_bufnr)
            local selection = action_state.get_selected_entry()
            if not selection then
              return
            end
            local session = selection.value
            -- Open in CURRENT nvim directory, not the session's original directory
            _G.opencode_open_terminal(vim.fn.getcwd(), session.title, session.id)
          end)
          return true
        end,
      }):find()
    end

    function _G.opencode_open_terminal(dir, title, session_id)
      -- Close existing opencode window if any
      if opencode_win and vim.api.nvim_win_is_valid(opencode_win) then
        vim.api.nvim_win_close(opencode_win, true)
        opencode_win = nil
      end
      if opencode_buf and vim.api.nvim_buf_is_valid(opencode_buf) then
        vim.api.nvim_buf_delete(opencode_buf, { force = true })
        opencode_buf = nil
      end

      -- Open right-side terminal (vnew creates window + buffer together)
      vim.cmd("botright vnew")
      opencode_win = vim.api.nvim_get_current_win()
      vim.api.nvim_win_set_width(opencode_win, 55)
      -- Re-use the buffer that vnew created, don't make a new one
      opencode_buf = vim.api.nvim_win_get_buf(opencode_win)
      -- Hide terminal buffer from buffer list (won't show in <S-h>/<S-l> cycling)
      vim.api.nvim_buf_set_option(opencode_buf, "buflisted", false)

      -- Name the buffer BEFORE termopen so it shows immediately
      if title then
        pcall(function()
          vim.api.nvim_buf_set_name(opencode_buf, "opencode: " .. title)
        end)
      end

      -- Get the oneclick binary path from the wrapper script
      local function get_oneclick_bin()
        local wrapper_path = vim.fn.exepath("opencode")
        if wrapper_path == "" then return nil end
        local lines = vim.fn.readfile(wrapper_path)
        for i, line in ipairs(lines) do
          if line:match("opencode%-oneclick%*%)") then
            local next_line = lines[i + 1] or ""
            local bin = next_line:match("exec%s+(%S+)")
            if bin and vim.fn.filereadable(bin) == 1 then
              return bin
            end
          end
        end
        return nil
      end

      local oneclick_bin = get_oneclick_bin()
      if not oneclick_bin then
        vim.notify("Could not find opencode-oneclick binary", vim.log.levels.ERROR)
        vim.api.nvim_win_close(opencode_win, true)
        return
      end

      -- Start opencode with --session to open SPECIFIC session
      local shell_cmd
      if session_id then
        shell_cmd = "cd " .. vim.fn.shellescape(dir) .. " && " .. vim.fn.shellescape(oneclick_bin) .. " --session " .. vim.fn.shellescape(session_id)
      else
        shell_cmd = "cd " .. vim.fn.shellescape(dir) .. " && " .. vim.fn.shellescape(oneclick_bin)
      end
      vim.fn.termopen(shell_cmd, {
        on_exit = function(job_id, exit_code, event_type)
          vim.schedule(function()
            -- Close the window and clean up when opencode exits
            if opencode_win and vim.api.nvim_win_is_valid(opencode_win) then
              local wins = vim.api.nvim_tabpage_list_wins(0)
              if #wins > 1 then
                vim.api.nvim_win_close(opencode_win, true)
              end
            end
            if opencode_buf and vim.api.nvim_buf_is_valid(opencode_buf) then
              vim.api.nvim_buf_delete(opencode_buf, { force = true })
            end
            opencode_buf = nil
            opencode_win = nil
          end)
        end,
      })

      vim.cmd("startinsert")
    end

    -- Direct toggle: opens session picker
    function _G.toggle_opencode()
      _G.opencode_pick_session()
    end

    vim.api.nvim_create_user_command("OpenCode", function()
      _G.toggle_opencode()
    end, {})
  '';

  keymaps = [
    {
      mode = "n";
      key = "<leader>aa";
      action = "<cmd>AvanteToggle<cr>";
      options.desc = "Avante AI sidebar";
    }
    {
      mode = "n";
      key = "<leader>ac";
      action = "<cmd>AvanteChat<cr>";
      options.desc = "Avante chat";
    }
    {
      mode = "n";
      key = "<leader>ae";
      action = "<cmd>AvanteEdit<cr>";
      options.desc = "Avante edit selection";
    }
    {
      mode = "n";
      key = "<leader>ao";
      action = "<cmd>OpenCode<cr>";
      options.desc = "OpenCode sessions";
    }
    {
      mode = "v";
      key = "<leader>ae";
      action = "<cmd>AvanteEdit<cr>";
      options.desc = "Avante edit selection";
    }
  ];
}

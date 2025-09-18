local f = "<leader>f"

-- Factory function to create live args configurations
local function create_live_args(type, include_content_args)
  local prefix = type == "rg" and "" or "fzf_"
  local args = {
    ["<C-g>"] = { "add_" .. prefix .. (type == "rg" and "glob" or "file"), mode = { "i", "n" } },
    ["<C-i>"] = { "add_" .. prefix .. (type == "rg" and "iglob" or "ifile"), mode = { "i", "n" } },
    ["<C-p>"] = { "add_" .. prefix .. (type == "rg" and "path_glob" or "path"), mode = { "i", "n" } },
    ["<C-P>"] = { "add_" .. prefix .. (type == "rg" and "path_iglob" or "ipath"), mode = { "i", "n" } },
  }

  if include_content_args then
    args["<C-k>"] = { "quote_prompt", mode = { "i", "n" } }
    if type == "rg" then
      args["<C-t>"] = { "add_type_filter", mode = { "i", "n" } }
    end
  end

  return args
end

local rg_live_args = create_live_args("rg", true)
local fzf_live_args = create_live_args("fzf", true)
local rg_file_args = create_live_args("rg", false)
local fzf_file_args = create_live_args("fzf", false)

return {
  "folke/snacks.nvim",
  lazy = false,
  opts = {
    picker = {
      layout = {
        preset = "telescope",
        reverse = true,
        layout = {
          width = 0.925,
          height = 0.925,
        },
      },

      sources = {
        files = {
          hidden = true,
          ignored = false,
          exclude = {
            ".luarc.json",
            "node_modules",
            ".git",
            "tags",
            "dist",
            ".DS_Store",
            "build",
            "out",
            ".next",
            "vim-sessions",
            ".vercel",
            ".netlify",
            "lcov-report",
            "__snapshots__",
            "lazy-lock.json",
            "lazyvim.json",
            ".local",
            "share",
            "\\.venv",
            ".coverage",
            ".repro",
            ".nx",
            "package-lock.json",
          },
        },
        grep = {
          hidden = true,
          ignored = false,
          exclude = {
            "tags",
            "node_modules",
            ".git",
            "dist",
            "build",
            ".next",
            "__snapshots__",
            "lcov-report",
            ".coverage",
            ".nx",
            "\\.venv",
          },
        },
      },

      -- Custom actions for live args functionality
      actions = {
        -- Quote current input (like <C-k> in telescope)
        quote_prompt = function(picker)
          local input = picker.input:get()
          picker.input:set('"' .. input .. '"')
        end,

        -- Add extension glob pattern (like <C-g> in telescope)
        add_glob = function(picker)
          local input = picker.input:get()
          local new_input = input .. " --glob '**/*."
          picker.input:set(new_input)
          -- Position cursor after the dot
          vim.schedule(function()
            if picker.input.win and vim.api.nvim_win_is_valid(picker.input.win) then
              local pos = vim.api.nvim_win_get_cursor(picker.input.win)
              vim.api.nvim_win_set_cursor(picker.input.win, { pos[1], #new_input - 1 }) -- before closing quote
            end
          end)
        end,

        -- Add inverse extension glob pattern (like <C-i> in telescope)
        add_iglob = function(picker)
          local input = picker.input:get()
          local new_input = input .. " --glob !'**/*."
          picker.input:set(new_input)
          -- Position cursor after the dot
          vim.schedule(function()
            if picker.input.win and vim.api.nvim_win_is_valid(picker.input.win) then
              local pos = vim.api.nvim_win_get_cursor(picker.input.win)
              vim.api.nvim_win_set_cursor(picker.input.win, { pos[1], #new_input - 1 }) -- before closing quote
            end
          end)
        end,

        -- Add file type filter (like <C-t> in telescope)
        add_type_filter = function(picker)
          local input = picker.input:get()
          local new_input = input .. " --type "
          picker.input:set(new_input)
          -- Position cursor at the end
          vim.schedule(function()
            if picker.input.win and vim.api.nvim_win_is_valid(picker.input.win) then
              local pos = vim.api.nvim_win_get_cursor(picker.input.win)
              vim.api.nvim_win_set_cursor(picker.input.win, { pos[1], #new_input })
            end
          end)
        end,

        -- Add path glob pattern
        add_path_glob = function(picker)
          local input = picker.input:get()
          local new_input = input .. " --glob '"
          picker.input:set(new_input)
          -- Position cursor after the quote
          vim.schedule(function()
            if picker.input.win and vim.api.nvim_win_is_valid(picker.input.win) then
              local pos = vim.api.nvim_win_get_cursor(picker.input.win)
              vim.api.nvim_win_set_cursor(picker.input.win, { pos[1], #new_input })
            end
          end)
        end,

        -- Add inverse path glob pattern
        add_path_iglob = function(picker)
          local input = picker.input:get()
          local new_input = input .. " --glob !'"
          picker.input:set(new_input)
          -- Position cursor after the quote
          vim.schedule(function()
            if picker.input.win and vim.api.nvim_win_is_valid(picker.input.win) then
              local pos = vim.api.nvim_win_get_cursor(picker.input.win)
              vim.api.nvim_win_set_cursor(picker.input.win, { pos[1], #new_input })
            end
          end)
        end,

        -- FZF-style actions
        -- Add file pattern (FZF style)
        add_fzf_file = function(picker)
          local input = picker.input:get()
          local new_input = input .. " file:*."
          picker.input:set(new_input)
          -- Position cursor after the dot
          vim.schedule(function()
            if picker.input.win and vim.api.nvim_win_is_valid(picker.input.win) then
              local pos = vim.api.nvim_win_get_cursor(picker.input.win)
              vim.api.nvim_win_set_cursor(picker.input.win, { pos[1], #new_input })
            end
          end)
        end,

        -- Add inverse file pattern (FZF style)
        add_fzf_ifile = function(picker)
          local input = picker.input:get()
          local new_input = input .. " !file:*."
          picker.input:set(new_input)
          -- Position cursor after the dot
          vim.schedule(function()
            if picker.input.win and vim.api.nvim_win_is_valid(picker.input.win) then
              local pos = vim.api.nvim_win_get_cursor(picker.input.win)
              vim.api.nvim_win_set_cursor(picker.input.win, { pos[1], #new_input })
            end
          end)
        end,

        -- Add path pattern (FZF style)
        add_fzf_path = function(picker)
          local input = picker.input:get()
          local new_input = input .. " file:"
          picker.input:set(new_input)
          -- Position cursor at the end
          vim.schedule(function()
            if picker.input.win and vim.api.nvim_win_is_valid(picker.input.win) then
              local pos = vim.api.nvim_win_get_cursor(picker.input.win)
              vim.api.nvim_win_set_cursor(picker.input.win, { pos[1], #new_input })
            end
          end)
        end,

        -- Add inverse path pattern (FZF style)
        add_fzf_ipath = function(picker)
          local input = picker.input:get()
          local new_input = input .. " !file:"
          picker.input:set(new_input)
          -- Position cursor at the end
          vim.schedule(function()
            if picker.input.win and vim.api.nvim_win_is_valid(picker.input.win) then
              local pos = vim.api.nvim_win_get_cursor(picker.input.win)
              vim.api.nvim_win_set_cursor(picker.input.win, { pos[1], #new_input })
            end
          end)
        end,
      },

      -- Key mappings that recreate your telescope shortcuts
      win = {
        input = {
          keys = {
            -- Navigation and selection (matching your telescope mappings)
            ["<M-q>"] = { "qflist", mode = { "i", "n" } },
            ["<M-a>"] = { "select_and_next", mode = { "i", "n" } },
            ["<M-r>"] = { "select_and_prev", mode = { "i", "n" } },
            ["<M-A>"] = { "select_all", mode = { "i", "n" } },
            ["<M-f>"] = { "list_scroll_up", mode = { "i", "n" } },
            ["<M-b>"] = { "list_scroll_down", mode = { "i", "n" } },

            -- Preview mappings
            ["<M-u>"] = { "preview_scroll_up", mode = { "i", "n" } },
            ["<M-d>"] = { "preview_scroll_down", mode = { "i", "n" } },
            ["<M-z>"] = { "list_scroll_center", mode = { "i", "n" } },

            -- Help mapping
            ["<M-w>"] = { "toggle_help_input", mode = { "i", "n" } },
          },
        },
        list = {
          keys = {
            -- Same mappings for list window
            ["<M-q>"] = "qflist",
            ["<M-a>"] = "select_and_next",
            ["<M-r>"] = "select_and_prev",
            ["<M-A>"] = "select_all",
            ["<M-f>"] = "list_scroll_up",
            ["<M-b>"] = "list_scroll_down",
            ["<M-u>"] = "preview_scroll_up",
            ["<M-d>"] = "preview_scroll_down",
            ["<M-z>"] = "list_scroll_center",
            ["<M-w>"] = "toggle_help_list",
          },
        },
      },
    },
  },
  keys = function()
    return {
      --
      -- Core file and search operations
      --
      {
        f .. "f",
        function()
          Snacks.picker.files({
            title = "Files (rg)",
            win = {
              input = {
                keys = rg_file_args,
              },
            },
          })
        end,
        desc = "Files (rg)",
      },
      {
        f .. "j",
        function()
          Snacks.picker.grep({
            title = "Live Grep (rg)",
            live = true,
            win = {
              input = {
                keys = rg_live_args,
              },
            },
          })
        end,
        desc = "Live Grep (rg)",
      },
      {
        f .. "J",
        function()
          Snacks.picker.grep({
            title = "Live Grep (fzf)",
            live = true,
            matcher = { fuzzy = true },
            win = {
              input = {
                keys = fzf_live_args,
              },
            },
          })
        end,
        desc = "Live Grep (fzf)",
      },
      {
        f .. "F",
        function()
          Snacks.picker.files({
            title = "Files (fzf)",
            matcher = { fuzzy = true },
            win = {
              input = {
                keys = fzf_file_args,
              },
            },
          })
        end,
        desc = "Files (fzf)",
      },
      {
        f .. "a",
        function()
          local current_file = vim.api.nvim_buf_get_name(0)
          local current_dir = vim.fn.fnamemodify(current_file, ":h")
          Snacks.picker.files({
            title = "Files Adjacent to Current",
            cwd = current_dir,
            win = {
              input = {
                keys = rg_file_args,
              },
            },
          })
        end,
        desc = "Files adjacent to current file",
      },
      {
        f .. "s",
        function()
          Snacks.picker.grep_word()
        end,
        desc = "Grep word under cursor",
      },
      {
        f .. "v",
        function()
          -- Get visual selection
          vim.cmd('noau normal! "vy"')
          local text = vim.fn.getreg("v")
          Snacks.picker.grep({ search = text })
        end,
        desc = "Grep visual selection",
        mode = "v",
      },
      {
        f .. "h",
        function()
          Snacks.picker.search_history()
        end,
        desc = "Search history",
      },
      {
        f .. "r",
        function()
          Snacks.picker.resume()
        end,
        desc = "Resume previous search",
      },

      --
      -- Changes, location and quickfix lists
      --
      {
        f .. "cu",
        function()
          Snacks.picker.undo()
        end,
        desc = "Undo tree",
      },
      {
        f .. "cf",
        function()
          Snacks.picker.qflist()
        end,
        desc = "Quickfix",
      },
      {
        f .. "cj",
        function()
          Snacks.picker.jumps()
        end,
        desc = "Jumplist",
      },
      {
        f .. "cl",
        function()
          Snacks.picker.loclist()
        end,
        desc = "Location list",
      },

      --
      -- Buffers, tags and marks
      --
      {
        f .. "bm",
        function()
          Snacks.picker.marks()
        end,
        desc = "Marks",
      },
      {
        f .. "bb",
        function()
          Snacks.picker.buffers()
        end,
        desc = "Buffers",
      },
      {
        f .. "br",
        function()
          Snacks.picker.registers()
        end,
        desc = "Registers",
      },

      --
      -- Git operations
      --
      {
        f .. "gs",
        function()
          Snacks.picker.git_status()
        end,
        desc = "Git status",
      },
      {
        f .. "gc",
        function()
          Snacks.picker.git_log()
        end,
        desc = "Git commits",
      },
      {
        f .. "gb",
        function()
          Snacks.picker.git_branches()
        end,
        desc = "Git branches",
      },
      {
        f .. "gt",
        function()
          Snacks.picker.git_stash()
        end,
        desc = "Git stashes",
      },
      {
        f .. "gu",
        function()
          Snacks.picker.git_log_file()
        end,
        desc = "Git commits in buffer",
      },
      {
        f .. "gf",
        function()
          Snacks.picker.git_files()
        end,
        desc = "Git files",
      },
      {
        f .. "gd",
        function()
          Snacks.picker.git_diff()
        end,
        desc = "Git diff (hunks)",
      },

      --
      -- Documentation and help
      --
      {
        f .. "dm",
        function()
          Snacks.picker.man()
        end,
        desc = "Man pages",
      },
      {
        f .. "dH",
        function()
          Snacks.picker.help()
        end,
        desc = "Help tags",
      },
      {
        f .. "dk",
        function()
          Snacks.picker.keymaps()
        end,
        desc = "Keymaps",
      },
      {
        f .. "ds",
        function()
          Snacks.picker.spelling()
        end,
        desc = "Spelling suggestions",
      },

      --
      -- LSP operations
      --
      {
        f .. "lr",
        function()
          Snacks.picker.lsp_references()
        end,
        desc = "LSP references",
      },
      {
        f .. "ls",
        function()
          Snacks.picker.lsp_symbols()
        end,
        desc = "LSP document symbols",
      },
      {
        f .. "lt",
        function()
          Snacks.picker.lsp_workspace_symbols()
        end,
        desc = "LSP workspace symbols",
      },
      {
        f .. "ld",
        function()
          Snacks.picker.lsp_definitions()
        end,
        desc = "LSP definitions",
      },
      {
        f .. "lm",
        function()
          Snacks.picker.lsp_implementations()
        end,
        desc = "LSP implementations",
      },
      {
        f .. "ly",
        function()
          Snacks.picker.lsp_type_definitions()
        end,
        desc = "LSP type definitions",
      },

      --
      -- Diagnostics
      --
      {
        f .. "lD",
        function()
          Snacks.picker.diagnostics()
        end,
        desc = "Diagnostics",
      },

      --
      -- Misc operations
      --
      {
        f .. "mn",
        function()
          Snacks.picker.commands()
        end,
        desc = "Commands",
      },
      {
        f .. "ma",
        function()
          Snacks.picker.autocmds()
        end,
        desc = "Autocmds",
      },
      {
        f .. "mi",
        function()
          Snacks.picker.icons()
        end,
        desc = "Icons",
      },

      --
      -- Additional core operations
      --
      {
        f .. "e",
        function()
          Snacks.picker.recent()
        end,
        desc = "Recent files",
      },
      {
        f .. "w",
        function()
          Snacks.picker.smart()
        end,
        desc = "Smart find files",
      },
      {
        f .. "C",
        function()
          Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
        end,
        desc = "Find config files",
      },
      {
        f .. "n",
        function()
          Snacks.picker.notifications()
        end,
        desc = "Notifications",
      },

      --
      -- Buffer operations
      --
      {
        f .. "bl",
        function()
          Snacks.picker.lines()
        end,
        desc = "Buffer lines",
      },
      {
        f .. "bg",
        function()
          Snacks.picker.grep_buffers()
        end,
        desc = "Grep open buffers",
      },

      --
      -- Command operations
      --
      {
        f .. "mc",
        function()
          Snacks.picker.command_history()
        end,
        desc = "Command history",
      },
      {
        f .. "mt",
        function()
          Snacks.picker.treesitter()
        end,
        desc = "Treesitter symbols",
      },
      {
        f .. "mh",
        function()
          Snacks.picker.highlights()
        end,
        desc = "Highlights",
      },
      {
        f .. "mp",
        function()
          Snacks.picker.pickers()
        end,
        desc = "Available pickers",
      },
      {
        f .. "ml",
        function()
          Snacks.picker.lazy()
        end,
        desc = "Lazy plugin specs",
      },
      {
        f .. "mv",
        function()
          Snacks.picker.colorschemes()
        end,
        desc = "Colorschemes",
      },

      --
      -- LSP additional
      --
      {
        f .. "lC",
        function()
          Snacks.picker.lsp_config()
        end,
        desc = "LSP config",
      },

      --
      -- Diagnostic buffer specific
      --
      {
        f .. "lB",
        function()
          Snacks.picker.diagnostics_buffer()
        end,
        desc = "Buffer diagnostics",
      },

      --
      -- Clipboard
      --
      {
        f .. "my",
        function()
          Snacks.picker.cliphist()
        end,
        desc = "Clipboard history",
      },
    }
  end,
}

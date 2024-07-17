local k_cmd = require("helpers").k_cmd
local l = "<leader>"
local s = l .. "s"
local ll = l .. "ll"
local a = 'lua require("ts-node-action").'

return {
  {
    "chentoast/marks.nvim",
    opts = {
      default_mappings = true,
      builtin_marks = { ".", "<", ">", "^" },
      cyclic = true,
      force_write_shada = true,
      refresh_interval = 250,
      sign_priority = { lower = 10, upper = 15, builtin = 8, bookmark = 20 },
      excluded_filetypes = {},
      -- Bookmark as confusing/with a question
      bookmark_0 = {
        sign = "",
        annotate = true,
      },
      -- Bookmark as flagged/important
      bookmark_9 = {
        sign = "⚑",
        annotate = true,
      },
      -- Bookmark as wrong
      bookmark_8 = {
        sign = "",
        annotate = true,
      },
      -- Bookmark as known good
      bookmark_7 = {
        sign = "",
        annotate = true,
      },
      -- Bookmark as info (useful but not wrong/good/home)
      bookmark_6 = {
        sign = "",
        annotate = true,
      },
      -- Bookmark as home (where I'm currently working)
      bookmark_5 = {
        sign = "",
        annotate = true,
      },
      mappings = {
        next_bookmark0 = "]0",
        next_bookmark9 = "]9",
        next_bookmark8 = "]8",
        next_bookmark7 = "]7",
        next_bookmark6 = "]6",
        next_bookmark5 = "]5",
        prev_bookmark0 = "[0",
        prev_bookmark9 = "[9",
        prev_bookmark8 = "[8",
        prev_bookmark7 = "[7",
        prev_bookmark6 = "[6",
        prev_bookmark5 = "[5",
      },
    },
  },
  {
    "ckolkey/ts-node-action",
    dependencies = { "nvim-treesitter" },
    opts = {},
    keys = {
      k_cmd({
        key = ll .. "a",
        action = a .. "node_action()",
        desc = "Node action",
      }),
      k_cmd({
        key = ll .. "d",
        action = a .. "debug()",
        desc = "Debug node",
      }),
      k_cmd({
        key = ll .. "l",
        action = a .. "available_actions()",
        desc = "List available actions",
      }),
    },
  },
  { "andymass/vim-matchup" },
  { "winston0410/range-highlight.nvim", opts = {} },
  { "godlygeek/tabular", event = "VeryLazy" },
  {
    "karb94/neoscroll.nvim",
    config = function()
      require("neoscroll").setup({
        mappings = {
          "<C-u>",
          "<C-d>",
          "<C-b>",
          "<C-f>",
          "<C-y>",
          "<C-e>",
          "zt",
          "zz",
          "zb",
        },
        hide_cursor = false,
        stop_eof = true,
        respect_scrolloff = false,
        cursor_scrolls_alone = true,
        easing_function = "cubic",
        pre_hook = nil,
        post_hook = nil,
      })

      local t = {}
      t["<C-u>"] = { "scroll", { "-vim.wo.scroll", "true", "100" } }
      t["<C-d>"] = { "scroll", { "vim.wo.scroll", "true", "100" } }
      t["<C-b>"] = { "scroll", { "-vim.api.nvim_win_get_height(0)", "true", "150" } }
      t["<C-f>"] = { "scroll", { "vim.api.nvim_win_get_height(0)", "true", "150" } }
      t["<C-y>"] = { "scroll", { "-0.10", "false", "50" } }
      t["<C-e>"] = { "scroll", { "0.10", "false", "50" } }
      t["zt"] = { "zt", { "100" } }
      t["zz"] = { "zz", { "100" } }
      t["zb"] = { "zb", { "100" } }

      require("neoscroll.config").set_mappings(t)
    end,
  },
  { "kylechui/nvim-surround", config = true },
  {
    "olimorris/persisted.nvim",
    lazy = false,
    config = true,
    opts = {
      save_dir = vim.fn.expand(vim.fn.stdpath("data") .. "/sessions/"),
      silent = false,
      use_git_branch = true,
      default_branch = "main",
      -- Preferring to save and load manually since I keep switching branches recklessly
      autosave = false,
      should_autosave = nil,
      autoload = true,
      on_autoload_no_session = nil,
      follow_cwd = true,
      allowed_dirs = nil,
      ignored_dirs = nil,
      ignored_branches = nil,
      telescope = {
        reset_prompt = true,
        mappings = {
          change_branch = "<c-b>",
          copy_session = "<c-c>",
          delete_session = "<c-d>",
        },
        icons = {
          branch = " ",
          dir = " ",
          selected = " ",
        },
      },
    },
    keys = {
      k_cmd({
        key = s .. "s",
        action = "SessionSave",
        desc = "Save session",
      }),
      k_cmd({
        key = s .. "l",
        action = "SessionLoad",
        desc = "Load session",
      }),
      k_cmd({
        key = s .. "d",
        action = "SessionDelete",
        desc = "Delete session",
      }),
      k_cmd({
        key = s .. "l",
        action = "SessionLoadLast",
        desc = "Session load last",
      }),
    },
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>st", false },
      { "<leader>sT", false },
    },
  },
}

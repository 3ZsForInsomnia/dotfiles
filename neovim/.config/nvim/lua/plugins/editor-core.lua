local k_cmd = require("helpers").k_cmd
local l = "<leader>"
local z = l .. "zs"
local ll = l .. "ll"
local a = 'lua require("ts-node-action").'

return {
  {
    "folke/which-key.nvim",
    opts = {
      preset = "classic",
      win = {
        height = {
          min = 8,
          max = 12,
        },
        padding = {
          1,
          1,
        },
      },
      layout = {
        width = {
          max = 45,
        },
      },
    },
  },
  {
    "chentoast/marks.nvim",
    event = "VeryLazy",
    opts = {
      force_write_shada = true,
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
        delete_bookmark0 = "dm0",
        delete_bookmark9 = "dm9",
        delete_bookmark8 = "dm8",
        delete_bookmark7 = "dm7",
        delete_bookmark6 = "dm6",
        delete_bookmark5 = "dm5",
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
        key = z .. "s",
        action = "SessionSave",
        desc = "Save session",
      }),
      k_cmd({
        key = z .. "l",
        action = "SessionLoad",
        desc = "Load session",
      }),
      k_cmd({
        key = z .. "d",
        action = "SessionDelete",
        desc = "Delete session",
      }),
      k_cmd({
        key = z .. "a",
        action = "SessionLoadLast",
        desc = "Session load last",
      }),
    },
  },
  {
    "folke/todo-comments.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>st", false },
      { "<leader>sT", false },
    },
  },
  {
    "OXY2DEV/helpview.nvim",
    lazy = false,
  },
}

local v = vim
local k_cmd = require("helpers").k_cmd
local l = "<leader>"
local z = l .. "zs"
local ll = l .. "ll"
local a = 'lua require("ts-node-action").'

return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "classic",
      win = {
        no_overlap = false,
        height = {
          min = 12,
          max = 20,
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
    "ckolkey/ts-node-action",
    lazy = true,
    dependencies = { "nvim-treesitter" },
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
  { "godlygeek/tabular", ft = "markdown" },
  { "kylechui/nvim-surround", config = true },
  {
    "olimorris/persisted.nvim",
    lazy = false,
    config = true,
    opts = {
      save_dir = v.fn.expand(v.fn.stdpath("data") .. "/sessions/"),
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
    ft = {
      "html",
      "css",
      "scss",
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
      "go",
      "pythong",
      "bash",
      "zsh",
      "lua",
      "json",
    },
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      -- { "<leader>st", false },
      { "[t", false },
      { "]t", false },
      { "<leader>sT", false },
    },
  },
  {
    "OXY2DEV/helpview.nvim",
    lazy = false,
  },
}

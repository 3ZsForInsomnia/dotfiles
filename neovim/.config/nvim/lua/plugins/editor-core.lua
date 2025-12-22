local v = vim
local k_cmd = require("helpers").k_cmd
local l = "<leader>"
local z = l .. "zs"
local ca = l .. "ca"
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
      spec = {
        {
          mode = { "n", "v" },

          --
          -- <Leader>a
          --
          { "<leader>a", group = "What's the A stand for..." },

          --
          -- <Leader>b
          --
          { "<leader>b", group = "Buffers & Marks" },
          { "<leader>bh", group = "Horizontal splits" },
          { "<leader>bl", group = "Marks & Bookmarks" },
          { "<leader>bv", group = "New vertical split" },

          --
          -- <Leader>c
          --
          { "<leader>c", group = "Code (LSP)" },
          { "<leader>cl", group = "Code lens" },
          { "<leader>cw", group = "Workspaces" },

          --
          -- <Leader>d
          --
          { "<leader>d", group = "Debugging & Profiler" },
          { "<leader>D", group = "Databases" },
          { "<leader>dp", group = "Profiler" },

          --
          -- <Leader>e
          --
          { "<leader>e", group = "Explorer (Neotree)" },

          --
          -- <Leader>f Snacks Picker
          --
          { "<leader>f", group = "Snacks Picker" },
          { "<leader>fb", group = "Buffers, marks, registers and tags" },
          { "<leader>fc", group = "Changes, quick and location lists" },
          { "<leader>fd", group = "Docs and snippets" },
          { "<leader>fg", group = "Git" },
          { "<leader>fl", group = "LSP" },
          { "<leader>fm", group = "Misc" },

          --
          -- <Leader>h Http (using Kulala)
          --
          { "<leader>h", group = "HTTP" },

          --
          -- <Leader>g
          --
          { "<leader>g", group = "Git" },
          { "<leader>gd", group = "Diffview" },
          { "<leader>gh", group = "Gitsigns" },
          { "<leader>gn", group = "Neogit" },
          { "<leader>gp", group = "Octo PRs" },
          { "<leader>gc", group = "Octo Comments, Threads, Reactions" },
          -- { "<leader>gr", group = "Octo Reviews, Assignees" },

          --
          -- <Leader>s Surrounds
          --
          { "<leader>s", group = "Sessions and Custom Surrounds" },
          { "<leader>sw", group = "Swap params" },
          { '<leader>s"', desc = "Surround with '\"'" },
          { "<leader>s'", desc = "Surround with '" },
          { "<leader>s`", desc = "Surround with `" },
          { "<leader>s(", desc = "Surround with ()" },
          { "<leader>s{", desc = "Surround with {}" },
          { "<leader>s[", desc = "Surround with []" },
          { "<leader>s<", desc = "Surround with <>" },
          { "<leader>s$", desc = "Surround with ${}" },

          --
          -- <Leader>z Misc keybinds
          --
          { "<leader>z", group = "Misc" },
          { "<leader>zc", group = "Colortils" },
          { "<leader>ze", group = "Emmet" },
          { "<leader>zs", group = "Sessions" },

          --
          -- Uncategorized <Leader> bindings
          --
          { "<leader>k", group = "Kubectl and Docker" },
          { "<leader>l", group = "Location list" },
          { "<leader>n", group = "Obsidian" },
          { "<leader>na", group = "Helpers to add notes to AI context" },
          { "<leader>o", group = "Overseer" },
          { "<leader>p", group = "Revman" },
          { "<leader>q", group = "Quickfix" },
          { "<leader>r", group = "Refactoring" },
          { "<leader>t", group = "Testing" },
          { "<leader>u", group = "UI toggles" },
          { "<leader>ut", group = "Neovim Feature Toggles" },
          { "<leader>w", group = "Windows" },
          { "<leader>x", group = "Trouble Diagnostics" },
          { "<leader>y", group = "Yazi" },

          --
          -- Non-<Leader> bindings
          --
          { "z", group = "Folds" },
          { "z=", desc = "Spell Suggestions" },

          --
          -- Marks (m)
          --
          { "m", group = "Marks" },
          { "m0", desc = "Investigating" },
          { "m9", desc = "Flagged/important" },
          { "m8", desc = "Bad" },
          { "m7", desc = "Good" },
          { "m6", desc = "Info" },
          { "m5", desc = "Home" },

          --
          -- Previous ([)
          --
          { "[", group = "Previous..." },
          { "[b", desc = "Buffer" },
          { "[h", desc = "Hunk" },
          { "[0", desc = "Investigation bookmark" },
          { "[9", desc = "Flagged/important bookmark" },
          { "[8", desc = "Bad bookmark" },
          { "[7", desc = "Good bookmark" },
          { "[6", desc = "Info bookmark" },
          { "[5", desc = "Home bookmark" },
          { "[B", desc = "First buffer" },
          { "[Q", desc = "First error" },
          { "[T", desc = "Tag" },
          { "[<C-T>", desc = "Preview next tag" },

          --
          -- Next (])
          --
          { "]", group = "Next..." },
          { "]b", desc = "Buffer" },
          { "]h", desc = "Hunk" },
          { "]0", desc = "Investigation bookmark" },
          { "]9", desc = "Flagged/important bookmark" },
          { "]8", desc = "Bad bookmark" },
          { "]7", desc = "Good bookmark" },
          { "]6", desc = "Info bookmark" },
          { "]5", desc = "Home bookmark" },
          { "]B", desc = "Last buffer" },
          { "]Q", desc = "Last error" },
          { "]T", desc = "Tag" },
          { "]<C-T>", desc = "Preview previous tag" },

          --
          -- Ctrl
          --
          { "<C-w>o", desc = "Fullscreen current buffer if in buffer split" },
          { "<C-w>c", desc = "Close split" },
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
        key = ca .. "a",
        action = a .. "node_action()",
        desc = "Node action",
      }),
      k_cmd({
        key = ca .. "d",
        action = a .. "debug()",
        desc = "Debug node",
      }),
      k_cmd({
        key = ca .. "l",
        action = a .. "available_actions()",
        desc = "List available actions",
      }),
    },
  },
  { "andymass/vim-matchup" },
  { "winston0410/range-highlight.nvim", event = "VeryLazy" },
  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    config = true,
  },
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
  {
    "rcarriga/nvim-notify",
    opts = {
      max_width = 100,
      max_height = 10,
      minimum_width = 40,
      render = "wrapped-compact",
      timeout = 3000,
    },
  },
}

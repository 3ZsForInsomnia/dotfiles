local cmd = require("helpers").k_cmd

local l = "<leader>l"

return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile", "BufWritePre" },
    opts = {
      servers = {
        ["*"] = {
          keys = {
            { "<leader>ca", false },
            { "<leader>cA", false },
            { "<leader>cr", false },
            { "<leader>ub", false },
            { "<leader>ud", false },
            { "<leader>uf", false },
            { "<leader>uF", false },
            { "<leader>ug", false },
            { "<leader>uh", false },
            { "<leader>uH", false },
            { "<leader>ui", false },
            { "<leader>uI", false },
            { "<leader>ul", false },
            { "<leader>uL", false },
            { "<leader>us", false },
            { "<leader>ut", false },
            { "<leader>uT", false },
          },
        },
      },
    },
  },
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    opts = { use_diagnostic_signs = true },
    keys = {
      { "<leader>cs", false },
      { "<leader>cS", false },
    },
  },
  "mason-org/mason-lspconfig.nvim",
  {
    "mason-org/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    opts_extend = { "ensure_installed" },
    opts = {
      ensure_installed = {
        "bash-language-server",
        "css-lsp",
        "cspell",
        "dockerfile-language-server",
        "emmet-language-server",
        "eslint_d",
        "flake8",
        "graphql-language-service-cli",
        "html-lsp",
        "isort",
        -- "java-language-server",
        "jq",
        "json-lsp",
        "lua-language-server",
        "luacheck",
        -- "marksman",
        "nginx-language-server",
        "nxls",
        "prettier",
        "pyright",
        "shellcheck",
        "sqlfmt",
        "sqlls",
        "stylelint",
        "tailwindcss-language-server",
        "typescript-language-server",
        "vim-language-server",
      },
    },
    keys = {
      { "<leader>cm", false },
    },
  },
  {
    "aznhe21/actions-preview.nvim",
    lazy = true,
    config = true,
    keys = {
      cmd({
        key = l .. "a",
        action = "lua require('actions-preview').code_actions()",
        desc = "Get code actions",
      }),
    },
  },
  -- {
  --   "RRethy/nvim-treesitter-textsubjects",
  --   lazy = false,
  --   dependencies = { "nvim-treesitter/nvim-treesitter" },
  --   opts = {
  --     prev_selection = ",", -- (Optional) keymap to select the previous selection
  --     keymaps = {
  --       ["."] = "textsubjects-smart",
  --       [";"] = "textsubjects-container-outer",
  --       ["i;"] = "textsubjects-container-inner",
  --     },
  --   },
  -- },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    lazy = false,
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
          -- You can use the capture groups defined in textobjects.scm
          ["af"] = "@function.outer",
          ["if"] = "@function.inner",
          ["aa"] = "@call.outer",
          ["ia"] = "@call.inner",
          ["ac"] = "@class.outer",
          ["ic"] = "@class.inner",
          ["al"] = "@loop.outer",
          ["il"] = "@loop.inner",
          ["ai"] = "@conditional.outer",
          ["ii"] = "@conditional.inner",
          ["ao"] = "@block.outer",
          ["io"] = "@block.inner",
          ["am"] = "@comment.inner",
        },
      },
      move = {
        enable = true,
        set_jumps = true,
        goto_next_start = {
          ["[F"] = "@function.outer",
          ["[C"] = "@class.outer",
          ["[A"] = "@call.outer",
          ["[O"] = "@block.outer",
          ["[I"] = "@conditional.outer",
          ["[L"] = "@loop.outer",
        },
        goto_next_end = {
          ["]f"] = "@function.outer",
          ["]c"] = "@class.outer",
          ["]a"] = "@call.outer",
          ["]o"] = "@block.outer",
          ["]i"] = "@conditional.outer",
          ["]l"] = "@loop.outer",
        },
        goto_previous_start = {
          ["[f"] = "@function.outer",
          ["[c"] = "@class.outer",
          ["[a"] = "@call.outer",
          ["[o"] = "@block.outer",
          ["[i"] = "@conditional.outer",
          ["[l"] = "@loop.outer",
        },
        goto_previous_end = {
          ["]F"] = "@function.outer",
          ["]C"] = "@class.outer",
          ["]A"] = "@call.outer",
          ["]O"] = "@block.outer",
          ["]I"] = "@conditional.outer",
          ["]L"] = "@loop.outer",
        },
      },
      swap = {
        enable = true,
        swap_next = { ["<leader>swp"] = "@parameter.inner" },
        swap_previous = {
          ["<leader>swP"] = "@parameter.inner",
        },
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    branch = "main",
    build = ":TSUpdate",
    opts = {
      ignore_install = {},
      sync_install = true,
      auto_install = true,
    },
  },
}

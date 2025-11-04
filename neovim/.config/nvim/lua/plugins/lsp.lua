local cmd = require("helpers").k_cmd

local l = "<leader>l"
local f = function()
  return "lua vim.diagnostic."
end

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
        "java-language-server",
        "jq",
        "json-lsp",
        "lua-language-server",
        "luacheck",
        "marksman",
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
  { "RRethy/nvim-treesitter-textsubjects", lazy = true },
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      ensure_installed = {
        "awk",
        "css",
        "graphql",
        "http",
        "jq",
        "jsdoc",
      },
      ignore_install = {},
      sync_install = true,
      auto_install = true,
      highlight = {
        enable = true, -- false will disable the whole extension
        -- additional_vim_regex_highlighting = { "markdown" },
        disable = {}, -- list of language that will be disabled
      },
      textsubjects = {
        enable = true,
        prev_selection = ",", -- (Optional) keymap to select the previous selection
        keymaps = {
          ["."] = "textsubjects-smart",
          [";"] = "textsubjects-container-outer",
          ["i;"] = "textsubjects-container-inner",
        },
      },
      textobjects = {
        enable = true,
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
          swap_previous = { ["<leader>swP"] = "@parameter.inner" },
        },
      },
      indent = { enable = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "gnn",
          node_incremental = "grn",
          scope_incremental = "grc",
          node_decremental = "grm",
        },
      },
      autotag = { enable = true },
      matchup = { enable = true },
      pairs = {
        enable = true,
        disable = {},
        highlight_pair_events = { "CursorMoved" },
        highlight_self = false,
        goto_right_end = false,
        fallback_cmd_normal = "call matchit#Match_wrapper('',1,'n')",
        keymaps = {
          goto_partner = "%",
          delete_balanced = "X",
        },
        delete_balanced = {
          only_on_first_char = false,
          fallback_cmd_normal = nil,
          longest_partner = false,
        },
      },
    },
    keys = {
      cmd({
        key = l .. "e",
        action = f() .. "open_float()",
        desc = "Open floating diagnostics window ",
      }),
    },
  },
}

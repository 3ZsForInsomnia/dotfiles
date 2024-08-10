local cmd = require("helpers").k_cmd

local l = "<leader>l"
local f = function()
  return "lua vim.diagnostic."
end

return {
  {
    "neovim/nvim-lspconfig",
    opts = function()
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      keys[#keys + 1] = { "<leader>ca", false }
      keys[#keys + 1] = { "<leader>cA", false }
      keys[#keys + 1] = { "<leader>cr", false }
      keys[#keys + 1] = { "<leader>ub", false }
      keys[#keys + 1] = { "<leader>ud", false }
      keys[#keys + 1] = { "<leader>uf", false }
      keys[#keys + 1] = { "<leader>uF", false }
      keys[#keys + 1] = { "<leader>ug", false }
      keys[#keys + 1] = { "<leader>uh", false }
      keys[#keys + 1] = { "<leader>uH", false }
      keys[#keys + 1] = { "<leader>ui", false }
      keys[#keys + 1] = { "<leader>uI", false }
      keys[#keys + 1] = { "<leader>ul", false }
      keys[#keys + 1] = { "<leader>uL", false }
      keys[#keys + 1] = { "<leader>us", false }
      keys[#keys + 1] = { "<leader>ut", false }
      keys[#keys + 1] = { "<leader>uT", false }
    end,
  },
  {
    "folke/trouble.nvim",
    opts = { use_diagnostic_signs = true },
    keys = {
      { "<leader>cs", false },
      { "<leader>cS", false },
    },
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "angular-language-server",
        "bash-language-server",
        "black",
        "css-lsp",
        "cspell",
        "dockerfile-language-server",
        "emmet-language-server",
        "eslint_d",
        "flake8",
        "grammarly-languageserver",
        "graphql-language-service-cli",
        "html-lsp",
        "isort",
        "java-language-server",
        "js-debug-adapter",
        "jq",
        "json-lsp",
        "lua-language-server",
        "luacheck",
        "markdown-toc",
        "marksman",
        "nginx-language-server",
        "nxls",
        "pyright",
        "shellcheck",
        "shfmt",
        "sqlfmt",
        "sqlls",
        "stylua",
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
    config = true,
    keys = {
      cmd({
        key = l .. "a",
        action = "lua require('actions-preview').code_actions()",
        desc = "Get code actions",
      }),
    },
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    opts = {
      enable = true,
      patterns = {
        default = {
          "class",
          "function",
          "method",
          "for",
          "while",
          "if",
          "switch",
          "case",
          "interface",
          "struct",
          "enum",
        },
        tex = {
          "chapter",
          "section",
          "subsection",
          "subsubsection",
        },
        haskell = {
          "adt",
        },
        rust = {
          "impl_item",
        },
        terraform = {
          "block",
          "object_elem",
          "attribute",
        },
        scala = {
          "object_definition",
        },
        vhdl = {
          "process_statement",
          "architecture_body",
          "entity_declaration",
        },
        markdown = {
          "section",
        },
        elixir = {
          "anonymous_function",
          "arguments",
          "block",
          "do_block",
          "list",
          "map",
          "tuple",
          "quoted_content",
        },
        json = {
          "pair",
        },
        typescript = {
          "export_statement",
        },
        yaml = {
          "block_mapping_pair",
        },
      },
    },
    config = true,
  },
  { "nvim-treesitter/nvim-treesitter-textobjects" },
  { "RRethy/nvim-treesitter-textsubjects" },
  {
    "nvim-treesitter/nvim-treesitter",
    config = function()
      local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
      parser_config.markdown.used_by = "octo"

      require("nvim-treesitter.configs").setup({
        modules = {},
        ensure_installed = {
          "awk",
          "bash",
          "css",
          "gitignore",
          "graphql",
          "html",
          "http",
          "java",
          "javascript",
          "jq",
          "jsdoc",
          "json",
          "lua",
          "markdown",
          "python",
          "scss",
          "regex",
          "tsx",
          "typescript",
          "vim",
          "yaml",
        },
        ignore_install = {},
        sync_install = true,
        auto_install = true,
        highlight = {
          enable = true, -- false will disable the whole extension
          additional_vim_regex_highlighting = { "markdown" },
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
        rainbow = {
          enable = true,
          query = "rainbow-delimiters",
          strategy = require("rainbow-delimiters").strategy.global,
          extended_mode = true,
          max_file_lines = nil,
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
      })
    end,
    keys = {
      cmd({
        key = l .. "e",
        action = f() .. "open_float()",
        desc = "Open floating diagnostics window ",
      }),
    },
  },
}

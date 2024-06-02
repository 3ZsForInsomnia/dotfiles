return {
  {
    "folke/trouble.nvim",
    opts = { use_diagnostic_signs = true },
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
        "prettierd",
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
      }
    }
  },
  {
    "aznhe21/actions-preview.nvim",
    config = function()
      vim.keymap.set({ "v", "n" }, "gf", require("actions-preview").code_actions)
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    config = function()
      require 'treesitter-context'.setup {
        enable = true,
        patterns = {
          default = {
            'class',
            'function',
            'method',
            'for',
            'while',
            'if',
            'switch',
            'case',
            'interface',
            'struct',
            'enum',
          },
          tex = {
            'chapter',
            'section',
            'subsection',
            'subsubsection',
          },
          haskell = {
            'adt'
          },
          rust = {
            'impl_item',

          },
          terraform = {
            'block',
            'object_elem',
            'attribute',
          },
          scala = {
            'object_definition',
          },
          vhdl = {
            'process_statement',
            'architecture_body',
            'entity_declaration',
          },
          markdown = {
            'section',
          },
          elixir = {
            'anonymous_function',
            'arguments',
            'block',
            'do_block',
            'list',
            'map',
            'tuple',
            'quoted_content',
          },
          json = {
            'pair',
          },
          typescript = {
            'export_statement',
          },
          yaml = {
            'block_mapping_pair',
          },
        },
      }
    end,
  },
  { "nvim-treesitter/nvim-treesitter-textobjects" },
  { "RRethy/nvim-treesitter-textsubjects" },
  {
    "nvim-treesitter/nvim-treesitter",
    config = function()
      require("nvim-treesitter.configs").setup({
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
        sync_install = true,
        auto_install = true,
        highlight = {
          enable = true, -- false will disable the whole extension
          additional_vim_regex_highlighting = { "markdown" },
          disable = {},  -- list of language that will be disabled
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
    end
  }
}

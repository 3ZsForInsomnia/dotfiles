local M = {}

function M.setup()
  require 'nvim-treesitter.configs'.setup {
    ensure_installed = {
      "javascript",
      "lua",
      "awk",
      "bash",
      "gitignore",
      "graphql",
      "java",
      "jq",
      "jsdoc",
      "json",
      "html",
      "markdown",
      "python",
      "scss",
      "css",
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
      disable = {}, -- list of language that will be disabled
    },
    refactor = {
      highlight_definitions = { enable = true },
      highlight_current_scope = { enable = false },
      smart_rename = {
        enable = true,
        keymaps = {
          smart_rename = "grr",
        },
      },
      navigation = {
        enable = true,
        keymaps = {
          goto_definition = "gnd",
          list_definitions = "gnD",
          list_definitions_toc = "gO",
          goto_next_usage = "<a-*>",
          goto_previous_usage = "<a-#>",
        },
      },
    },
    textsubjects = {
      enable = true,
      prev_selection = ',', -- (Optional) keymap to select the previous selection
      keymaps = {
        ['.'] = 'textsubjects-smart',
        [';'] = 'textsubjects-container-outer',
        ['i;'] = 'textsubjects-container-inner',
      },
    },
    textobjects = {
      select = {
        enable = true,
        -- Automatically jump forward to textobj, similar to targets.vim
        lookahead = true,
        keymaps = {
          -- You can use the capture groups defined in textobjects.scm
          ["af"] = "@function.outer",
          ["if"] = "@function.inner",
          ["ac"] = "@class.outer",
          ["ic"] = "@class.inner"
        }
      },
      move = {
        enable = true,
        set_jumps = true,
        goto_next_start = {
          ['[M'] = '@function.outer',
          [']['] = '@class.outer'
        },
        goto_next_end = {
          [']m'] = '@function.outer',
          [']]'] = '@class.outer'
        },
        goto_previous_start = {
          ['[m'] = '@function.outer',
          ['[['] = '@class.outer'
        },
        goto_previous_end = {
          [']M'] = '@function.outer',
          ['[]'] = '@class.outer'
        }
      },
      swap = {
        enable = true,
        swap_next = { ["<leader>xp"] = "@parameter.inner" },
        swap_previous = { ["<leader>xP"] = "@parameter.inner" }
      }
      -- possible text objects:
      -- @block.inner
      -- @block.outer
      -- @call.inner
      -- @call.outer
      -- @class.inner
      -- @class.outer
      -- @comment.outer
      -- @conditional.inner
      -- @conditional.outer
      -- @function.inner
      -- @function.outer
      -- @loop.inner
      -- @loop.outer
      -- @parameter.inner
      -- @statement.outer
    },
    indent = {
      enable = true,
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = '<CR>',
        scope_incremental = '<CR>',
        node_incremental = '<TAB>',
        node_decremental = '<S-TAB>',
      },
    },
    rainbow = {
      enable = true,
      -- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
      extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
      max_file_lines = nil, -- Do not enable for files with more than n lines, int
      -- colors = {}, -- table of hex strings
      -- termcolors = {} -- table of colour name strings
    },
    autotag = {
      enable = true,
    },
    matchup = {
      enable = true,
    },
  }
end

return M

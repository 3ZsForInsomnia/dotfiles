local g = vim.g
local cmd = require("helpers").k_cmd

local h = "<leader>h"
local k = function(command)
  return "lua require('kulala')." .. command .. "()"
end

return {
  {
    "mistweaverco/kulala.nvim",
    ft = { "http", "rest", "gql", "graphql" },
    keys = {
      cmd({
        key = h .. "a",
        action = "enew<cr><cmd>set filetype=http",
        desc = "Open new HTTP buffer",
      }),
      cmd({
        key = h .. "A",
        action = k("scratchpad"),
        desc = "Open http scratchpad",
      }),
      cmd({
        key = h .. "C",
        action = k("close"),
        desc = "Close http scratchpad",
      }),
      cmd({
        key = h .. "t",
        action = k("toggle_view"),
        desc = "Toggle headers/body",
      }),
      cmd({
        key = h .. "s",
        action = k("show_stats"),
        desc = "Show stats",
      }),
      cmd({
        key = h .. "e",
        action = k("download_graphql_schema"),
        desc = "Download Gql Schema",
      }),
      cmd({
        key = h .. "c",
        action = k("run"),
        desc = "Run HTTP request",
      }),
      cmd({
        key = h .. "i",
        action = k("inspect"),
        desc = "Inspect HTTP request",
      }),
      cmd({
        key = h .. "p",
        action = k("jump_prev"),
        desc = "Jump to previous request",
      }),
      cmd({
        key = h .. "n",
        action = k("jump_next"),
        desc = "Jump to next request",
      }),
      cmd({
        key = h .. "r",
        action = k("replay"),
        desc = "Replay HTTP request",
      }),
    },
  },
  {
    "yoshio15/vim-trello",
    event = "VeryLazy",
    config = function()
      g.vimTrelloApiKey = os.getenv("TRELLO_API_KEY")
      g.vimTrelloToken = os.getenv("TRELLO_API_TOKEN")
    end,
  },
  {
    "ramilito/kubectl.nvim",
    config = true,
    keys = {
      cmd({
        key = "<leader>ko",
        action = "lua require('kubectl').open()",
        desc = "Open kubectl buffer",
      }),
      cmd({
        key = "<leader>kc",
        action = "lua require('kubectl').close()",
        desc = "Close kubectl buffer",
      }),
      cmd({
        key = "<leader>kt",
        action = "lua require('kubectl').toggle()",
        desc = "Toggle kubectl buffer",
      }),
    },
  },
  {
    "numToStr/Comment.nvim",
    config = true,
  },
  {
    "liuchengxu/vista.vim",
    event = "VeryLazy",
    config = function()
      g.vista_default_executive = "nvim_lsp"
      g.vista_sidebar_position = "vertical topleft"
      g.vista_sidebar_width = 35
    end,
  },
  {
    "mbbill/undotree",
    event = "VeryLazy",
    keys = {
      cmd({
        key = "<leader>uu",
        action = "UndotreeToggle",
        desc = "Toggle UndoTree",
      }),
    },
  },
  {
    "lewis6991/hover.nvim",
    event = "VeryLazy",
    config = function()
      require("hover").setup({
        init = function()
          require("hover.providers.lsp")
          require("hover.providers.gh")
          require("hover.providers.jira")
          require("hover.providers.dictionary")
          require("hover.providers.dap")
          require("hover.providers.fold_preview")
          require("hover.providers.diagnostic")
          require("hover.providers.man")
          require("hover.providers.gh_user")
        end,

        preview_opts = {
          border = "single",
          width = 50,
        },
        preview_window = true,
        title = true,
      })
    end,
    keys = {
      cmd({
        key = "<C-k>",
        action = "lua require('hover').hover()",
        desc = "Hover",
      }),
      cmd({
        key = "<C-h>",
        action = "lua require('hover').hover_switch('next')",
        desc = "Hover next",
      }),
      cmd({
        key = "<C-l>",
        action = "lua require('hover').hover_switch('previous')",
        desc = "Hover prev",
      }),
      cmd({
        key = "<M-f>",
        action = "lua require('hover').hover_select()",
        desc = "Hover select",
      }),
    },
  },
  {
    "m4xshen/hardtime.nvim",
    event = "VeryLazy",
    opts = {
      -- The "" filetype is for `nofile`, which is used by VimTrello
      disabled_filetypes = {
        "netrw",
        "lazy",
        "mason",
        "neo-tree",
        "noice",
        "trouble",
        "dbui",
        "vista_kind",
        "dbout",
        "chatgpt-input",
        "copilot-chat",
        "NeogitPopup",
        "codecompanion",
        "octo",
      },
      max_count = 4,
      restricted_keys = {
        ["w"] = { "n", "x" },
        ["b"] = { "n", "x" },
      },
      hints = {
        ["0w"] = {
          message = function()
            return "Use ^ instead of 0w"
          end,
          length = 2,
        },
        ["wh"] = {
          message = function()
            return "Use e instead of wh"
          end,
          length = 2,
        },
      },
    },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "codecompanion" },
    opts = {
      completions = {
        blink = { enabled = true },
        lsp = { enabled = true },
      },
      file_types = { "markdown", "codecompanion" },
    },
  },
  -- {
  --   "OXY2DEV/markview.nvim",
  --   lazy = false,
  --   branch = "dev",
  --   ft = "markdown",
  --   dependencies = {
  --     "nvim-treesitter/nvim-treesitter",
  --     "nvim-tree/nvim-web-devicons",
  --   },
  --   opts = {
  --     preview = {
  --       filetypes = { "markdown", "codecompanion" },
  --       ignore_buftypes = {},
  --     },
  --   },
  --   config = function()
  --     local presets = require("markview.presets")
  --     return {
  --       headings = presets.headings.decorated_labels,
  --     }
  --   end,
  -- },
  {
    "luckasRanarison/tailwind-tools.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      {
        document_color = {
          enabled = true,
          kind = "inline",
          inline_symbol = "󰝤 ",
          debounce = 200,
        },
        conceal = {
          enabled = true,
          min_length = 1,
          symbol = "󱏿",
          highlight = {
            fg = "#38BDF8",
          },
        },
      },
    },
  },
  {
    "HakonHarnes/img-clip.nvim",
    opts = {
      filetypes = {
        codecompanion = {
          prompt_for_file_name = false,
          template = "[Image]($FILE_PATH)",
          use_absolute_path = true,
        },
      },
    },
    keys = {
      cmd({
        key = "<leader>zp",
        action = "PasteImage",
        desc = "Paste image form clipboard into buffer",
      }),
    },
  },
}

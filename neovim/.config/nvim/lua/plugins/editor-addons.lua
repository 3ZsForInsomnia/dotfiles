local cmd = require("helpers").k_cmd

return {
  {
    "numToStr/Comment.nvim",
    config = true,
  },
  {
    "liuchengxu/vista.vim",
    event = "VeryLazy",
    config = function()
      vim.cmd([[
         let g:vista_default_executive = 'nvim_lsp'
      ]])
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
      disabled_filetypes = { "netrw", "lazy", "mason", "neo-tree", "noice", "trouble", "dbui", "vista_kind" },
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
    "yoshio15/vim-trello",
    config = function()
      require("config.trello")
    end,
  },
  {
    "OXY2DEV/markview.nvim",
    ft = "markdown",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      local presets = require("markview.presets")
      return {
        headings = presets.headings.decorated_labels,
      }
    end,
  },
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
}

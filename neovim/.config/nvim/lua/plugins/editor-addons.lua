local cmd = require("helpers").k_cmd
local k = require("helpers").k
local db = "<leader>db"
local dba = function(command)
  return "DBUI " .. command
end

return {
  {
    "numToStr/Comment.nvim",
    config = true,
  },
  {
    "liuchengxu/vista.vim",
    event = "VeryLazy",
    keys = {
      cmd({
        key = "<leader>uv",
        action = "Vista!!",
        desc = "Toggle Vista",
      }),
    },
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
    "folke/twilight.nvim",
    event = "VeryLazy",
  },
  {
    "lewis6991/hover.nvim",
    event = "VeryLazy",
    config = function()
      require("hover").setup({
        init = function()
          require("hover.providers.lsp")
          require("hover.providers.gh")
          require("hover.providers.gh_user")
          require("hover.providers.jira")
          require("hover.providers.dictionary")
          require("hover.providers.dap")
          require("hover.providers.fold_preview")
          require("hover.providers.diagnostic")
          require("hover.providers.man")

          -- Custom providers
          -- trelloProvider()
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
        key = "<M-d>",
        action = "lua require('hover').hover()",
        desc = "Hover",
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
      disabled_filetypes = { "netrw", "lazy", "mason", "neo-tree", "noice", "trouble" },
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
  { "tpope/vim-dadbod", event = "VeryLazy" },
  {
    "kristijanhusak/vim-dadbod-ui",
    event = "VeryLazy",
    keys = {
      cmd({
        key = db .. "t",
        action = dba("Toggle"),
        desc = "Toggle DBUI",
      }),
      cmd({
        key = db .. "f",
        action = dba("FindBuffer"),
        desc = "Find buffer",
      }),
      cmd({
        key = db .. "r",
        action = dba("RenameBuffer"),
        desc = "Rename buffer",
      }),
      cmd({
        key = db .. "l",
        action = dba("LastQueryInfo"),
        desc = "Last query info",
      }),
    },
  },
  {
    "yoshio15/vim-trello",
    config = function()
      require("config.trello")
    end,
  },
}
-- compromise

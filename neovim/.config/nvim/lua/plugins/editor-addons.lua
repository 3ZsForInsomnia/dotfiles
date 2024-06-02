return {
  { "numToStr/Comment.nvim", config = true },
  { "liuchengxu/vista.vim",  event = "VeryLazy", },
  { "mbbill/undotree" },
  { "folke/twilight.nvim",   config = true,      event = "VeryLazy", },
  {
    "lewis6991/hover.nvim",
    config = function()
      require("hover").setup({
        init = function()
          require("hover.providers.lsp")
          require("hover.providers.gh")
          require("hover.providers.gh_user")
          require("hover.providers.jira")

          -- Custom providers
          -- clickupProvider()
          -- trelloProvider()
        end,

        preview_opts = {
          border = "single",
          width = 50,
        },
      })

      vim.keymap.set("n", "K", require("hover").hover, { desc = "hover.nvim" })
      vim.keymap.set("n", "gK", require("hover").hover_select, { desc = "hover.nvim (select)" })
      vim.keymap.set("n", "<C-p>", function() require("hover").hover_switch("previous") end,
        { desc = "hover.nvim (previous source)" })
      vim.keymap.set("n", "<C-n>", function() require("hover").hover_switch("next") end,
        { desc = "hover.nvim (next source)" })
    end
  },
  { "tpope/vim-dadbod",             event = "VeryLazy" },
  { "kristijanhusak/vim-dadbod-ui", event = "VeryLazy" },
  {
    "m4xshen/hardtime.nvim",
    event = "VeryLazy",
    opts = {
      disabled_filetypes = { "netrw", "lazy", "mason", "neo-tree" },
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
      }
    }
  }
}

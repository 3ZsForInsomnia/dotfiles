local cmd = require("helpers").k_cmd

return {
  { "zdcthomas/yop.nvim" },
  { "winston0410/cmd-parser.nvim" },
  {
    "danymat/neogen",
    opts = {
      snippet_engine = "luasnip",
    },
  },
  {
    "vhyrro/luarocks.nvim",
    priority = 1000,
    config = true,
    opts = {
      rocks = { "lua-curl", "nvim-nio", "mimetypes", "xml2lua" },
    },
  },
  {
    "mistweaverco/kulala.nvim",
    config = function()
      -- Setup is required, even if you don't pass any options
      require("kulala").setup({
        -- default_view, body or headers
        default_view = "body",
        -- dev, test, prod, can be anything
        -- see: https://learn.microsoft.com/en-us/aspnet/core/test/http-files?view=aspnetcore-8.0#environment-files
        default_env = "dev",
        -- enable/disable debug mode
        debug = false,
        -- default formatters for different content types
        formatters = {
          json = { "jq", "." },
          xml = { "xmllint", "--format", "-" },
          html = { "xmllint", "--format", "--html", "-" },
        },
        icons = {
          inlay = {
            loading = "⏳",
            done = "✅ ",
          },
          lualine = "🐼",
        },
        -- additional cURL options
        -- e.g. { "--insecure", "-A", "Mozilla/5.0" }
        additional_curl_options = {},
      })
    end,
    keys = {
      cmd({
        key = "<leader>zr",
        action = "lua require('kulala').run()",
        desc = "Send a request",
      }),
      cmd({
        key = "[r",
        action = "lua require('kulala').jump_prev()",
        desc = "Jump to previous request",
      }),
      cmd({
        key = "]r",
        action = "lua require('kulala').jump_next()",
        desc = "Jump to next request",
      }),
    },
  },
  {
    "mistricky/codesnap.nvim",
    build = "make build_generator",
    opts = {
      save_path = "/home/zach/Pictures/Screenshots/code",
      has_breadcrumbs = true,
      bg_theme = "bamboo",
    },
    -- TODO: Update these
    keys = {
      { "<leader>zsc", "<cmd>CodeSnap<cr>", mode = "x", desc = "Save selected code snapshot into clipboard" },
      { "<leader>zss", "<cmd>CodeSnapSave<cr>", mode = "x", desc = "Save selected code snapshot in ~/Pictures" },
    },
  },
}

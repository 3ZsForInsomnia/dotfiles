local cmd = require("helpers").k_cmd

return {
  {
    "folke/noice.nvim",
    enabled = false,
    opts = {
      popupmenu = {
        enabled = true,
        backend = "nui",
        kind_icons = {
          Class = " ",
          Color = " ",
          Constant = " ",
          Constructor = " ",
          Enum = "了 ",
          EnumMember = " ",
          Field = " ",
          File = " ",
          Folder = " ",
          Function = " ",
          Interface = " ",
          Keyword = " ",
          Method = "ƒ ",
          Module = " ",
          Property = " ",
          Snippet = " ",
          Struct = " ",
          Text = " ",
          Unit = " ",
          Value = " ",
          Variable = " ",
        },
      },
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = true,
        lsp_doc_border = true,
      },
      views = {
        popup = {
          width = 150,
          height = 20,
        },
        split = {
          enter = true,
        },
      },
      routes = {
        {
          view = "split",
          filter = { event = "msg_show", min_height = 20 },
        },
        {
          view = "popup",
          filter = { event = "msg_show", min_length = 280 },
        },
        {
          filter = {
            event = "notify",
            find = "Request textDocument/inlayHint failed",
          },
          opts = { skip = true },
        },
      },
    },
    keys = {
      { "<leader>sna", false },
      { "<leader>snd", false },
      { "<leader>snh", false },
      { "<leader>snl", false },
      { "<leader>snt", false },
      cmd({
        key = "<leader>un",
        action = "Noice dismiss",
        desc = "Dismiss all Noice messages",
      }),
    },
  },
  {
    "brenoprata10/nvim-highlight-colors",
    ft = { "css", "scss", "html", "javascript", "typescript", "lua" },
    opts = {
      render = "background",
      enable_tailwind = true,
    },
  },
}

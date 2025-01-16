local cmd = require("helpers").k_cmd
local d = "<leader>D"
local dc = function(command)
  return "DBUI" .. command
end

return {
  {
    "tpope/vim-dadbod",
    event = "VeryLazy",
  },
  {
    "kristijanhusak/vim-dadbod-ui",
    event = "VeryLazy",
    config = function()
      vim.cmd([[
        let g:db_ui_use_nvim_notify = 1
        let g:db_ui_use_nerd_fonts = 1
      ]])
    end,
    keys = {
      cmd({
        key = d .. "o",
        action = dc(""),
        desc = "Open DBUI",
      }),
      cmd({
        key = d .. "c",
        action = dc("Close"),
      }),
      cmd({
        key = d .. "t",
        action = dc("Toggle"),
        desc = "Toggle DBUI",
      }),
      cmd({
        key = d .. "f",
        action = dc("FindBuffer"),
        desc = "Find buffer",
      }),
      cmd({
        key = d .. "r",
        action = dc("RenameBuffer"),
        desc = "Rename buffer",
      }),
      cmd({
        key = d .. "l",
        action = dc("LastQueryInfo"),
        desc = "Last query info",
      }),
    },
  },
}

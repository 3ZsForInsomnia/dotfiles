require("config.keymaps.lsp")
require("config.keymaps.surrounds")
require("config.keymaps.luasnip")

local k_cmd = require("helpers").k_cmd
local k = require("helpers").k
local l = "<leader>"

_G.logThis = function(str)
  local ft = vim.bo.filetype
  str = string.gsub(str, "%s+", "")

  if ft == "javascript" or ft == "typescript" or ft == "javascriptreact" or ft == "typescriptreact" then
    return 'console.log("' .. str .. '", ' .. str .. ");"
  elseif ft == "lua" then
    return 'print("' .. str .. '", vim.inspect(' .. str .. "))"
  end

  return "echo $" .. str
end

k_cmd({ key = l .. ",", action = "nohlsearch", desc = "Clear search highlights" })
k({
  key = l .. "zl",
  action = 'vaw"qyo<c-r>=luaeval(\'logThis(vim.fn.getreg("q"))\')<cr><esc><up>',
  desc = "Insta-log anything while in normal mode",
})
k_cmd({ key = l .. "zz", action = "w", desc = "Save file" })
k_cmd({ key = l .. "zy", action = "let @+ = expand('%:.')", desc = "Copy file path to clipboard" })

k({ key = "<C-c>", action = '"+y', desc = "Copy to clipboard", mode = "v" })

k({ key = "<esc>", action = "<C-\\><C-n>", desc = "Escape but for terminal mode", mode = "t" })

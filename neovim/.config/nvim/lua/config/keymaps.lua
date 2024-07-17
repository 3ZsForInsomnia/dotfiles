local d = vim.keymap.del

--
-- Disable global keymaps
--
d("n", "H")
d("n", "L")
d("n", "<leader>l")
d("n", "<leader>L")
d("n", "<leader>-")
d("n", "<leader>`")
d("n", "<leader>|")
d("n", "<leader>K")
d("n", "<leader>fn")
d("n", "<leader>fT")
d("n", "<leader>ft")
d("n", "<leader>gB")
d("n", "<leader>gb")
d("n", "<leader>gf")
d("n", "<leader>gG")
d("n", "<leader>gg")
d("n", "<leader>gL")
d("n", "<leader>gl")
d("n", "<leader>la")
d("n", "<leader><TAB>[")
d("n", "<leader><TAB>]")
d("n", "<leader><TAB><TAB>")
d("n", "<leader><TAB>d")
d("n", "<leader><TAB>f")
d("n", "<leader><tab>l")
d("n", "<leader><TAB>o")
-- d("n", "<leader>w-")
-- d("n", "<leader>w|")
-- d("n", "<leader>wd")
-- d("n", "<leader>wm")
-- d("n", "<leader>ww")
d("n", "<leader>uw")
d("n", "<leader>us")
d("n", "<leader>ur")
d("n", "<leader>uT")
d("n", "<leader>ut")
d("n", "<leader>uf")
d("n", "<leader>uF")
d("n", "<leader>ub")

--
-- Misc keymaps
--
local helpers = require("helpers")
local k = helpers.k
local k_cmd = helpers.k_cmd

local l = "<leader>"

k_cmd({
  key = l .. "ua",
  action = "TSBufToggle highlight",
  desc = "Toggle Treesitter Highlight",
})
k_cmd({
  key = l .. "ub",
  action = "TSBufToggle context",
  desc = "Toggle Treesitter Context",
})
k_cmd({
  key = "<leader>ut",
  action = "Twilight",
  desc = "Toggle Twilight",
})

k_cmd({ key = l .. ",", action = "nohlsearch", desc = "Clear search highlights" })
k_cmd({ key = l .. "zz", action = "w", desc = "Save file" })

k({ key = "<esc>", action = "<C-\\><C-n>", desc = "Escape but for terminal mode", mode = "t" })

k_cmd({ key = l .. "zy", action = "let @+ = expand('%:.')", desc = "Copy file path to clipboard" })
k({ key = "<C-c>", action = '"+y', desc = "Copy to clipboard", mode = "v" })

k({
  key = "zh",
  action = "Hzz",
  desc = "Go to top of page and center cursor",
})
k({
  key = "zl",
  action = "Lzz",
  desc = "Go to bottom of page and center cursor",
})

vim.keymap.set("n", "<M-b>", function()
  require("hover").hover_switch("previous")
end, { desc = "Hover previous" })
vim.keymap.set("n", "<M-f>", function()
  require("hover").hover_switch("next")
end, { desc = "Hover previous" })

require("config.keymaps.maps")
require("config.whichkey-map")

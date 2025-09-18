local d = vim.keymap.del

-- Disable global keymaps
--
d("n", "H")
d("n", "L")
d("n", "<leader>l")
d("n", "<leader>L")
d("n", "<leader>-")
d("n", "<leader>`")
d("n", "<leader>|")
d("n", "<leader>e")
d("n", "<leader>fn")
d("n", "<leader>fT")
d("n", "<leader>ft")
d("n", "<leader>gb")
d("n", "<leader>gg")
d("n", "<leader>K")
d("n", "<leader>la")
d("n", "<leader><TAB>[")
d("n", "<leader><TAB>]")
d("n", "<leader><TAB><TAB>")
d("n", "<leader><TAB>d")
d("n", "<leader><TAB>f")
d("n", "<leader><tab>l")
d("n", "<leader><TAB>o")
d("n", "<leader>fr")
d("n", "<leader>fR")

-- Disable default snacks picker keymaps
d("n", "<leader><space>")
d("n", "<leader>,")
d("n", "<leader>/")
d("n", "<leader>:")
-- d("n", "<leader>n")
-- d("n", "<leader>e")
d("n", "<leader>fb")
d("n", "<leader>fc")
d("n", "<leader>fg")
d("n", "<leader>fe")
d("n", "<leader>fE")
-- d("n", "<leader>fp")
-- d("n", "<leader>fr")
-- d("n", "<leader>gl")
-- d("n", "<leader>gL")
-- d("n", "<leader>gs")
-- d("n", "<leader>gS")
-- d("n", "<leader>gd")
-- d("n", "<leader>gf")
d("n", "<leader>sb")
-- d("n", "<leader>sB")
d("n", "<leader>sg")
d("n", "<leader>sw")
d("n", '<leader>s"')
-- d("n", "<leader>s/")
d("n", "<leader>sa")
d("n", "<leader>sc")
d("n", "<leader>sC")
d("n", "<leader>sd")
d("n", "<leader>sD")
d("n", "<leader>sh")
d("n", "<leader>sH")
-- d("n", "<leader>si")
d("n", "<leader>sj")
d("n", "<leader>sk")
d("n", "<leader>sl")
d("n", "<leader>sm")
d("n", "<leader>sM")
-- d("n", "<leader>sp")
d("n", "<leader>sq")
d("n", "<leader>sR")
-- d("n", "<leader>su")
d("n", "<leader>uC")
-- d("n", "gd")
-- d("n", "gD")
-- d("n", "gr")
-- d("n", "gI")
-- d("n", "gy")
d("n", "<leader>ss")
d("n", "<leader>sS")
d("n", "<leader>sG")
d("n", "<leader>sn")
d("v", "<leader>sw")
d("n", "<leader>sW")
d("n", "<leader>sr")

--
-- Misc keymaps
--
local helpers = require("helpers")
local k = helpers.k
local k_cmd = helpers.k_cmd

local l = "<leader>"

_G.clear_search_status_virtual_text = function()
  vim.cmd("nohlsearch")

  local bufnr = vim.api.nvim_get_current_buf()
  local ns_id = vim.api.nvim_create_namespace("search_status_virtual_text")
  vim.api.nvim_buf_clear_namespace(bufnr, ns_id, 0, -1)
end

k_cmd({ key = l .. ",", action = "lua clear_search_status_virtual_text()", desc = "Clear search highlights" })
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

k_cmd({ key = l .. "zu", action = "Lazy update", desc = "Lazy update" })

k_cmd({
  key = "[b",
  action = "bprev",
  desc = "Previous buffer",
})
k_cmd({
  key = "]b",
  action = "bnext",
  desc = "Next buffer",
})

require("config.keymaps.maps")

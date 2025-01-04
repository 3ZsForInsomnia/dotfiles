local cmd = require("helpers").k_cmd
local s = require("snacks").toggle

local l = "<leader>u"

--
-- UI Toggles
--
s.dim():map(l .. "D")
s.indent():map(l .. "i")
s.treesitter():map(l .. "a")
cmd({
  key = l .. "c",
  action = "TailwindConcealToggle",
  desc = "Toggle Tailwind Conceal",
})

local h = "<leader>gh"

cmd({
  key = h .. "t",
  action = "Gitsigns toggle_current_line_blame",
  desc = "Toggle blame line in virutal text on cursor line",
})
cmd({
  key = h .. "d",
  action = "Gitsigns toggle_deleted",
  desc = "Show deleted lines",
})

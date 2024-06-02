local wk = require("which-key")
local d = vim.diagnostic

wk.register({
  ['<leader>l'] = {
    name = "LSP Diagnostics",
    e = { function() d.open_float() end, "Open floating diagnostic window" },
    l = { function() d.setloclist() end, "Set diagnostics in loclist" },
    q = { function() d.setqflist() end, "Add all diagnostics to quickfix" },
  },
  ['[d'] = { function() d.goto_prev({}) end, "Previous diagnostic" },
  [']d'] = { function() d.goto_next() end, "Next diagnostic" },
})

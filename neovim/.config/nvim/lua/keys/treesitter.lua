local wk = require("which-key")

wk.register({
  ['<leader>l'] = {
    name = "LSP Diagnostics",
    e = { function() vim.diagnostic.open_float() end, "Open floating diagnostic window" },
    l = { function() vim.diagnostic.setloclist() end, "Set diagnostics in loclist" },
    q = { function() vim.diagnostic.setqflist() end, "Add all diagnostics to quickfix" },
    pt = { "<cmd>TSPlaygroundToggle<cr>", "TS Playground Toggle" },
  },
  ['[d'] = { function() vim.diagnostic.goto_prev({}) end, "Previous diagnostic" },
  [']d'] = { function() vim.diagnostic.goto_next() end, "Next diagnostic" },
  
})


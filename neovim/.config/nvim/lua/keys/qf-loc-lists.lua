local wk = require('which-key')

wk.register({
  c = {
    name = "Quickfix list",
    c = { "<cmd>cclose<cr>", "Close" },
    o = { "<cmd>copen<cr>", "Open" },
    n = { "<cmd>cn<cr>", "Next" },
    p = { "<cmd>cp<cr>", "Previous" },
    t = { "<cmd>tab copen<cr>", "Open in new tab" },
    l = { "<cmd>cexpr []<cr>", "Clear" },
    d = { "<cmd>colder<cr>", "Go to older list" },
    u = { "<cmd>cnewer<cr>", "Go to newer list" },
    f = { ":Cfilter! /f/<left>", "Filter and create new qf list" },
    h = { "<cmd>caddexpr expand('%') .. ':' .. line('.') ..  ':' .. getline('.')<cr>", "Add cursor location to qf list" },
    s = { ":vimgrep //%<left><left>", "Search and add results to qflist" },
    qt = { "<cmd>TodoQuickFix<cr>", "Add all todos in project to qflist" },
  },
  l = {
    name = "LocList",
    c = { "<cmd>lclose<cr>", "Close" },
    o = { "<cmd>lopen<cr>", "Open" },
    n = { "<cmd>lnext<cr>", "Next" },
    p = { "<cmd>lprev<cr>", "Previous" },
    l = { "<cmd>lexpr []<cr>", "Clear" },
    d = { "<cmd>lolder<cr>", "Go to older list" },
    u = { "<cmd>lnewer<cr>", "Go to newer list" },
    f = { ":Lfilter! /f/<left>", "Filter and create new qf list" },
    h = { "<cmd>laddexpr expand('%') .. ':' .. line('.') ..  ':' .. getline('.')<cr>", "Add cursor location to qf list" },
    s = { ":lvimgrep //%<left><left>", "Search and add results to loclist" },
    lt = { "<cmd>TodoLocList<cr>", "Add all todos in file to loclist" },
  },
}, { prefix = "<leader>" })

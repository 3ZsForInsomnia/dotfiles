local wk = require("which-key")

local f = function(number)
  return "<cmd>LualineBuffersJump! " .. number .. "<cr>"
end

wk.register({
  t = {
    name = "Tabs",
    n = { "<cmd>tabnew<cr>", "Open a new tab" },
    nt = { "<cmd>tabnew<cr><cmd>terminal<cr>", "Open a terminal in a new tab" },
    no = { function() vim.api.nvim_command(":tabe " .. vim.fn.expand("%:p:h")) end, "Open file in dir of current buffer" },
    h = { "<cmd>split<cr>", "Horizontal split" },
    v = { "<cmd>vsplit<cr>", "Vertical split" },
  },
  b = {
    name = "Buffers",
    k = { "<cmd>bd<cr>", "Kill buffer" },
    o = { "<cmd>buffers<cr>", "View open buffers" },
    n = { "<cmd>new<cr>", "New buffer with horizontal split" },
    v = { "<cmd>vnew<cr>", "New buffer with vertical split" },
    t = { "<cmd>bd!<cr>", "Kill terminal/Exit immediately" },
    ['1'] = { f(1), "Jump to Buffer 1" },
    ['2'] = { f(2), "Jump to Buffer 2" },
    ['3'] = { f(3), "Jump to Buffer 3" },
    ['4'] = { f(4), "Jump to Buffer 4" },
    ['5'] = { f(5), "Jump to Buffer 5" },
    ['6'] = { f(6), "Jump to Buffer 6" },
    ['7'] = { f(7), "Jump to Buffer 7" },
    ['8'] = { f(8), "Jump to Buffer 8" },
    ['9'] = { f(9), "Jump to Buffer 9" },
    ['0'] = { f(0), "Jump to Buffer 10" },
    a = { f(11), "Jump to Buffer 11" },
    b = { f(12), "Jump to Buffer 12" },
  },
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
    s = { ":lvimgrep //%<left><left>", "Search and add results to loclist" },
    lt = { "<cmd>TodoLocList<cr>", "Add all todos in file to loclist" },
  },
}, { prefix = "<leader>" })

wk.register({
  [']b'] = { "<cmd>bn<cr>", "Go to next buffer" },
  ['[b'] = { "<cmd>bp<cr>", "Go to previous buffer" },
})

local keymap = vim.keymap.set
local silent = { silent = true }
keymap("n", "<C-h>", "<C-w>h", silent)
keymap("n", "<C-j>", "<C-w>j", silent)
keymap("n", "<C-k>", "<C-w>k", silent)
keymap("n", "<C-l>", "<C-w>l", silent)

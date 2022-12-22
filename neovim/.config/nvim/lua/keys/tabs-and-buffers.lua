local wk = require("which-key")
wk.register({
  t = {
    name = "Tabs",
    t = { "<cmd>CHADopen<cr>", "ChadTree Open" },
    n = { "<cmd>tabnew<cr>", "Open a new tab" },
    nt = { "<cmd>tabnew<cr><cmd>terminal<cr>", "Open a terminal in a new tab" },
    no = { function() print(":tabe " .. vim.fn.expand("%:p:h")) end, "Open file in dir of current buffer" },
    c = { "<cmd>tabnew<cr><cmd>CHADopen<cr><C-h>Jc", "Open ChadTree at current file" },
    h = { "<cmd>split<cr>", "Horizontal split" },
    v = { "<cmd>vsplit<cr>", "Vertical split" },
  },
  b = {
    name = "Buffers",
    n = { "<cmd>new<cr>", "New buffer with horizontal split" },
    nv = { "<cmd>vnew<cr>", "New buffer with vertical split" },
    tk = { "<cmd>bd!<cr>", "Kill terminal/Exit immediately" },
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
  },
}, { prefix = "<leader>" })

local f = function(number)
  return "<cmd>LualineBuffersJump! " .. number .. "<cr>"
end

wk.register({
  gt = { "<cmd>bn<cr>", "Go to next buffer" },
  gT = { "<cmd>bp<cr>", "Go to previous buffer" },
  gk = { "<cmd>bd<cr>", "Kill buffer" },
  gv= { "<cmd>buffers<cr>", "View open buffers" },
  g1 = { f(1), "Jump to Buffer 1" },
  g2 = { f(2), "Jump to Buffer 2" },
  g3 = { f(3), "Jump to Buffer 3" },
  g4 = { f(4), "Jump to Buffer 4" },
  g5 = { f(5), "Jump to Buffer 5" },
  g6 = { f(6), "Jump to Buffer 6" },
  g7 = { f(7), "Jump to Buffer 7" },
  g8 = { f(8), "Jump to Buffer 8" },
  g9 = { f(9), "Jump to Buffer 9" },
  g0 = { f(0), "Jump to Buffer 10" },
  ga = { f(11), "Jump to Buffer 11" },
  gb = { f(12), "Jump to Buffer 12" },
})

local keymap = vim.keymap.set
local silent = { silent = true }
keymap("n", "<C-h>", "<C-w>h", silent)
keymap("n", "<C-j>", "<C-w>j", silent)
keymap("n", "<C-k>", "<C-w>k", silent)
keymap("n", "<C-l>", "<C-w>l", silent)
-- keymap("n", "<leader>tno", ":tabe %%", silent)

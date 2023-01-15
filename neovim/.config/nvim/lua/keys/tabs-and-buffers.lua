local wk = require("which-key")

local f = function(number)
  return "<cmd>LualineBuffersJump! " .. number .. "<cr>"
end

wk.register({
  ['<leader>'] = {
    t = {
      name = "Tabs",
      w = { "<C-w>T", "Move current split to new tab" },
      n = { "<cmd>tabnew<cr>", "Open a new tab" },
      nt = { "<cmd>tabnew<cr><cmd>terminal<cr>", "Open a terminal in a new tab" },
      no = { function() vim.api.nvim_command(":tabe " .. vim.fn.expand("%:p:h")) end,
        "Open file in dir of current buffer" },
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
    h = {
      ['+'] = { "<C-w>10>", "Increase horizontal split size by 8" },
      ['-'] = { "<C-w>10<", "Decrease horizontal split size by 8" },
    },
    v = {
      ['+'] = { "<C-w>10+", "Increase vertical split size by 8" },
      ['-'] = { "<C-w>10-", "Decrease vertical split size by 8" },
    },
    ['='] = { "<C-w>=", "Equalize split sizes" },
  },
  ['[b'] = { "<cmd>bp<cr>", "Go to previous buffer" },
  [']b'] = { "<cmd>bn<cr>", "Go to next buffer" },
  ['<M-h'] = "Focus on pane to left",
  ['<M-j'] = "Focus on pane to below",
  ['<M-k'] = "Focus on pane to above",
  ['<M-l'] = "Focus on pane to right",
})

local keymap = vim.keymap.set
local silent = { silent = true }
keymap("n", "<M-h>", "<C-w>h", silent)
keymap("n", "<M-j>", "<C-w>j", silent)
keymap("n", "<M-k>", "<C-w>k", silent)
keymap("n", "<M-l>", "<C-w>l", silent)

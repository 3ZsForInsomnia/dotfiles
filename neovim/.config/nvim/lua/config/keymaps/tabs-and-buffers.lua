local helpers = require("helpers")
local k = helpers.k
local cmd = helpers.k_cmd

local f = function(number)
  return "<cmd>LualineBuffersJump! " .. number .. "<cr>"
end

-- local b = "<leader>b"
local b = "b"

k({
  key = b .. "n",
  action = "<cmd>new<cr><C-w>o",
  desc = "New buffer",
})
k({
  key = b .. "t",
  action = "<cmd>new<cr><C-w>o<cmd>terminal<cr>",
  desc = "New terminal buffer",
})
cmd({
  key = b .. "k",
  action = "bd",
  desc = "Close buffer",
})
k({
  key = b .. "g",
  action = ":b ",
  desc = "Go to buffer",
})
k({
  key = b .. "c",
  action = "<C-g>",
  desc = "Show path",
})
cmd({
  key = b .. "a",
  action = "b#",
  desc = "Go to last edited buffer",
})
k({
  key = b .. "r",
  action = ":bd ",
  desc = "Kill buffers by name/pattern",
})
k({
  key = b .. "o",
  action = "lua vim.api.nvim_command(':e ' .. vim.fn.expand('%:p:h'))",
  desc = "Open file in dir of current buffer",
})
cmd({
  key = b .. "q",
  action = "bd!",
  desc = "Kill buffer immediately (including terminal buffers)",
})
k({
  key = b .. "1",
  action = f(1),
  desc = "Jump to buffer 1",
})
k({
  key = b .. "2",
  action = f(2),
  desc = "Jump to buffer 2",
})
k({
  key = b .. "3",
  action = f(3),
  desc = "Jump to buffer 3",
})
k({
  key = b .. "4",
  action = f(4),
  desc = "Jump to buffer 4",
})
k({
  key = b .. "5",
  action = f(5),
  desc = "Jump to buffer 5",
})
k({
  key = b .. "6",
  action = f(6),
  desc = "Jump to buffer 6",
})
k({
  key = b .. "7",
  action = f(7),
  desc = "Jump to buffer 7",
})
k({
  key = b .. "8",
  action = f(8),
  desc = "Jump to buffer 8",
})
k({
  key = b .. "9",
  action = f(9),
  desc = "Jump to buffer 9",
})
k({
  key = b .. "0",
  action = f(0),
  desc = "Jump to buffer 10",
})

local s = b .. "h"

cmd({
  key = s .. "n",
  action = "split",
  desc = "New horizontal split",
})
k({
  key = s .. "+",
  action = "<C-w>10>",
  desc = "Increase horizontal split size",
})
k({
  key = s .. "-",
  action = "<C-w>10<",
  desc = "Decrease horizontal split size",
})

local v = b .. "v"

cmd({
  key = v .. "n",
  action = "vsplit",
  desc = "New vertical split",
})
k({
  key = v .. "+",
  action = "<C-w>10+",
  desc = "Increase vertical split size",
})
k({
  key = v .. "-",
  action = "<C-w>10-",
  desc = "Decrease vertical split size",
})

k({
  key = b .. "=",
  action = "<C-w>=",
  desc = "Equalize splits",
})

cmd({
  key = "[b",
  action = "bp",
  desc = "Previous buffer",
})
cmd({
  key = "]b",
  action = "bn",
  desc = "Next buffer",
})

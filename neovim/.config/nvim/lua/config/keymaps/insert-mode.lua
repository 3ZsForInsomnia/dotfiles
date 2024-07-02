local k = require("helpers").k

k({
  key = "<C-l>",
  action = '<esc>vaw"qyo<c-r>=luaeval(\'logThis(vim.fn.getreg("q"))\')<cr><up>',
  desc = "Insta-log anything while in insert mode",
  mode = "i",
})

k({
  key = "<C-c>",
  action = "<esc>`^",
  desc = "Escape and keep location",
  mode = "i",
})

k({
  key = "<C-w>",
  action = "<c-g>u<c-w>",
  desc = "Delete word backwards",
  mode = "i",
})

k({
  key = "<C-u>",
  action = "<c-g>u<c-u>",
  desc = "Delete to start of line",
  mode = "i",
})

k({
  key = "<C-x>",
  action = "<c-o>dw",
  desc = "Delete word forwards",
  mode = "i",
})

k({
  key = "<C-d>",
  action = "<c-o>D",
  desc = "Delete to end of line",
  mode = "i",
})

local k = require("helpers").k

k({
  key = "<C-c>",
  action = "<esc>`^",
  desc = "Escape and keep location",
  mode = "i",
})

k({
  key = "<C-a>",
  action = "<C-o>b",
  desc = "Move one word backwards",
  mode = "i",
})

k({
  key = "<C-;>",
  action = "<C-o>w",
  desc = "Move one word forwards",
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

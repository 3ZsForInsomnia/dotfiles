local k = require("helpers").k

--
-- <C-w>: Delete one word backwards
-- <C-u>: Delete to the beginning of the line
-- <C-t>: Indent current line
--

k({
  key = "<C-z>",
  action = "<Cmd>lua require('telescope.builtin').spell_suggest()<CR>",
  desc = "Spellcheck current or previous word",
  mode = "i",
})

-- Just here because the other spellcheck thing is here
k({
  key = "z1",
  action = "[s1z=",
  desc = "Auto spellcheck previous mispelled word",
})

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
  action = "<C-o>e<C-o>l",
  desc = "Move one word forwards",
  mode = "i",
})

k({
  key = "<C-x>",
  action = "<c-o>de",
  desc = "Delete word forwards",
  mode = "i",
})

k({
  key = "<C-d>",
  action = "<c-o>D",
  desc = "Delete to end of line",
  mode = "i",
})

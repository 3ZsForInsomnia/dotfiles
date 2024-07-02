local k_cmd = require("helpers").k_cmd
local k = require("helpers").k
local c = "<C-"
local lsnip = "<Plug>luasnip-"

k_cmd({
  key = c .. "s>",
  action = "<cmd>lua require('luasnip.extras.select_choice')()<cr>",
  desc = "Open select popup for luasnip choice",
  mode = "v",
})

k({
  key = c .. "j>",
  action = lsnip .. "-next-choice",
  desc = "Cycle to next luasnip choice",
  mode = "s",
})
k({
  key = c .. "k>",
  action = lsnip .. "-prev-choice",
  desc = "Cycle to previous luasnip choice",
  mode = "s",
})
k({
  key = c .. "e>",
  action = lsnip .. "-expand-snippet",
  desc = "Expand luasnip snippet under cursor",
  mode = "s",
})
k_cmd({
  key = c .. "s>",
  action = "lua require('luasnip.extras').select_choice()",
  desc = "Open select popup for luasnip choice",
  mode = "s",
})

k({
  key = c .. "j>",
  action = lsnip .. "-next-choice",
  desc = "Cycle to next luasnip choice",
  mode = "i",
})
k({
  key = c .. "k>",
  action = lsnip .. "-prev-choice",
  desc = "Cycle to previous luasnip choice",
  mode = "i",
})
k({
  key = c .. "e>",
  action = lsnip .. "-expand-snippet",
  desc = "Expand luasnip snippet under cursor",
  mode = "i",
})
k_cmd({
  key = c .. "s>",
  action = "lua require('luasnip.extras').select_choice()",
  desc = "Open select popup for luasnip choice",
  mode = "i",
})

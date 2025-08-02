local l = "<leader>"
local k = require("helpers").k
local cmd = require("helpers").k_cmd

local q = l .. "q"
local c = l .. "l"

--
-- Quickfix list shortcuts
--
cmd({
  key = q .. "c",
  action = "cclose",
  desc = "Close quickfix list",
})
cmd({
  key = q .. "e",
  action = "cdo edit",
  desc = "Edit all files in quickfix list",
})
cmd({
  key = q .. "o",
  action = "copen",
  desc = "Open quickfix list",
})
cmd({
  key = q .. "n",
  action = "cn",
  desc = "Go to next quickfix item",
})
cmd({
  key = q .. "p",
  action = "cp",
  desc = "Go to previous quickfix item",
})
cmd({
  key = q .. "t",
  action = "copen",
  desc = "Toggle quickfix list",
})
cmd({
  key = q .. "l",
  action = "cexpr []",
  desc = "Clear",
})
cmd({
  key = q .. "d",
  action = "colder",
  desc = "Go to older quickfix list",
})
cmd({
  key = q .. "u",
  action = "cnewer",
  desc = "Go to newer quickfix list",
})
k({
  key = q .. "f",
  action = ":Cfilter! /f/<left>",
  desc = "Filter and create new quickfix list",
})
cmd({
  key = q .. "h",
  action = "caddexpr expand('%') .. ':' .. line('.') ..  ':' .. getline('.')",
  desc = "Add cursor location to qf list",
})
k({
  key = q .. "s",
  action = ":vimgrep //%<left><left>",
  desc = "Search and add results to qf list",
})
cmd({
  key = q .. "q",
  action = "TodoQuickFix",
  desc = "Search and add TODOs to qf list",
})
cmd({
  key = q .. "q",
  action = "lua vim.diagnostic.setqflist()",
  desc = "Add all diagnostics to quickfix list",
})

--
-- Location list shortcuts
--
cmd({
  key = c .. "c",
  action = "lclose",
  desc = "Close location list",
})
cmd({
  key = c .. "o",
  action = "lopen",
  desc = "Open location list",
})
cmd({
  key = c .. "n",
  action = "lnext",
  desc = "Go to next location item",
})
cmd({
  key = c .. "p",
  action = "lprev",
  desc = "Go to previous location item",
})
cmd({
  key = c .. "l",
  action = "lexpr []",
  desc = "Clear",
})
cmd({
  key = c .. "d",
  action = "lolder",
  desc = "Go to older location list",
})
cmd({
  key = c .. "u",
  action = "lnewer",
  desc = "Go to newer location list",
})
k({
  key = c .. "f",
  action = ":Lfilter! /f/<left>",
  desc = "Filter and create new location list",
})
cmd({
  key = c .. "h",
  action = "laddexpr expand('%') .. ':' .. line('.') ..  ':' .. getline('.')",
  desc = "Add cursor location to loc list",
})
k({
  key = c .. "s",
  action = ":lvimgrep //%<left><left>",
  desc = "Search and add results to loc list",
})
cmd({
  key = c .. "t",
  action = "TodoLocList",
  desc = "Search and add TODOs in file to loc list",
})
cmd({
  key = c .. "l",
  action = "lua vim.diagnostic.setloclist()",
  desc = "Add diagnostics to loclist",
})

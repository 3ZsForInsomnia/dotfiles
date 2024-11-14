local w = vim.wo
local s = vim.schedule
local cmd = require("helpers").k_cmd

local h = "<leader>gh"

local function map(mode, l, r, opts)
  opts = opts or {}
  -- opts.buffer = bufnr
  vim.keymap.set(mode, l, r, opts)
end

-- Navigation
map({ "n", "v" }, "]h", function()
  if w.diff then
    return "]c"
  end
  s(function()
    require("gitsigns").next_hunk()
  end)
  return "<Ignore>"
end, { expr = true })

map({ "n", "v" }, "[h", function()
  if w.diff then
    return "[c"
  end
  s(function()
    require("gitsigns").prev_hunk()
  end)
  return "<Ignore>"
end, { expr = true })

cmd({
  key = h .. "q",
  action = "Gitsigns setqflist all",
  desc = "Send all hunks in all files to qf list",
})
cmd({
  key = h .. "l",
  action = "require('gitsigns').setloclist(0, 0)",
  desc = "Send all hunks in current buffer to location list",
})

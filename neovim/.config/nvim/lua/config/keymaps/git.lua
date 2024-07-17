local w = vim.wo
local s = vim.schedule

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

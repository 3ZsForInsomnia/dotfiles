local cmd = require("helpers").k_cmd
local s = require("snacks").toggle

local l = "<leader>u"
local t = "<leader>ut"

--
-- Neovim Feature Toggles
--
s.option("treesitter"):map(t .. "a")
s.option("background", { on = "dark", off = "light" }):map(t .. "b")
s.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map(t .. "c")
s.diagnostics():map(t .. "d")
s.option("format"):map(t .. "f")
s.new({
  name = "Indentation Guides",
  get = function()
    return require("ibl.config").get_config(0).enabled
  end,
  set = function(state)
    require("ibl").set_buffer_config(0, { enabled = state })
  end,
}):map(t .. "g")
s.inlay_hints():map(t .. "h")
s.line_number():map(t .. "l")
s.option("relativenumber", { name = "Relative Number" }):map(t .. "L")
s({
  name = "Mini Pairs",
  get = function()
    return not vim.g.minipairs_disable
  end,
  set = function(state)
    vim.g.minipairs_disable = not state
  end,
}):map(t .. "l")
s.option("spell", { name = "Spelling" }):map(t .. "s")
s.option("wrap", { name = "Wrap" }):map(t .. "w")

local tsc = require("treesitter-context")
s({
  name = "Treesitter Context",
  get = tsc.enabled,
  set = function(state)
    if state then
      tsc.enable()
    else
      tsc.disable()
    end
  end,
}):map(t .. "t")

--
-- UI Toggles
--
cmd({
  key = l .. "c",
  action = "TailwindConcealToggle",
  desc = "Toggle Tailwind Conceal",
})
cmd({
  key = l .. "t",
  action = "Twilight",
  desc = "Toggle Twilight",
})

local h = "<leader>gh"

cmd({
  key = h .. "t",
  action = "Gitsigns toggle_current_line_blame",
  desc = "Toggle blame line in virutal text on cursor line",
})
cmd({
  key = h .. "d",
  action = "Gitsigns toggle_deleted",
  desc = "Show deleted lines",
})

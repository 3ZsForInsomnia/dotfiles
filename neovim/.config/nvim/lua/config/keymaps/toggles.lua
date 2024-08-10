local cmd = require("helpers").k_cmd

local l = "<leader>u"
local t = "<leader>ut"

--
-- Neovim Feature Toggles
--
LazyVim.toggle.map(t .. "a", LazyVim.toggle.treesitter)
LazyVim.toggle.map(t .. "b", LazyVim.toggle("background", { values = { "light", "dark" }, name = "Background" }))
LazyVim.toggle.map(
  t .. "c",
  LazyVim.toggle("conceallevel", { values = { 0, vim.o.conceallevel > 0 and vim.o.conceallevel or 2 } })
)
LazyVim.toggle.map(t .. "d", LazyVim.toggle.diagnostics)
LazyVim.toggle.map(t .. "f", LazyVim.toggle.format())
LazyVim.toggle.map(t .. "F", LazyVim.toggle.format(true))
LazyVim.toggle.map(t .. "g", {
  name = "Indention Guides",
  get = function()
    return require("ibl.config").get_config(0).enabled
  end,
  set = function(state)
    require("ibl").setup_buffer(0, { enabled = state })
  end,
})
LazyVim.toggle.map(t .. "h", LazyVim.toggle.inlay_hints)
LazyVim.toggle.map(t .. "l", LazyVim.toggle.number)
LazyVim.toggle.map(t .. "L", LazyVim.toggle("relativenumber", { name = "Relative Number" }))
LazyVim.toggle.map(t .. "p", {
  name = "Mini Pairs",
  get = function()
    return not vim.g.minipairs_disable
  end,
  set = function(state)
    vim.g.minipairs_disable = not state
  end,
})
LazyVim.toggle.map(t .. "s", LazyVim.toggle("spell", { name = "Spelling" }))
LazyVim.toggle.map(t .. "w", LazyVim.toggle("wrap", { name = "Wrap" }))

local tsc = require("treesitter-context")

LazyVim.toggle.map(t .. "t", {
  name = "Treesitter Context",
  get = tsc.enabled,
  set = function(state)
    if state then
      tsc.enable()
    else
      tsc.disable()
    end
  end,
})

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

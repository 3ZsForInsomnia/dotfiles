local cmd = require("helpers").k_cmd

local u = "<leader>u"

Snacks.toggle
  .new({
    name = "Vista",
    get = function()
      return vim.cmd("g:vista#sidebar#IsOpen()") == "1"
    end,
    set = function()
      vim.cmd("Vista!!")
    end,
  })
  :map(u .. "v")

Snacks.toggle
  .new({
    name = "Tailwind Conceal Level",
    get = function()
      return require("tailwind-tools.state").conceal.enabled
    end,
    set = function(value)
      local is_enabled = require("tailwind-tools.state").conceal.enabled == value
      if is_enabled then
        require("tailwind-tools.conceal").disable()
      else
        require("tailwind-tools.conceal").enable()
      end
    end,
  })
  :map(u .. "C")

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

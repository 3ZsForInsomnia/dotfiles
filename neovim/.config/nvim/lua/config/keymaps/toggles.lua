local u = "<leader>u"

Snacks.toggle
  .new({
    name = "Vista",
    get = function()
      return vim.fn["vista#sidebar#IsOpen"]() == 1
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

Snacks.toggle
  .new({
    name = "Gitsigns Current Line Blame",
    get = function()
      local config = require("gitsigns.config").config

      return config.current_line_blame
    end,
    set = function(value)
      require("gitsigns").toggle_current_line_blame(value)
    end,
  })
  :map(u .. "B")

Snacks.toggle
  .new({
    name = "Gitsigns Show Deleted",
    get = function()
      local config = require("gitsigns.config").config

      return config.show_deleted
    end,
    set = function(value)
      local gitsigns = require("gitsigns")
      local config = require("gitsigns.config").config

      config.show_deleted = value
      gitsigns.refresh()
    end,
  })
  :map(u .. "e")

local cmd = require("helpers").k_cmd
local l = "<leader>z"

local c = function(command)
  return "Colortils " .. command .. " #<cword>"
end

return {
  {
    "aklt/plantuml-syntax",
    event = "VeryLazy",
    ft = "uml",
  },
  {
    "weirongxu/plantuml-previewer.vim",
    event = "VeryLazy",
    ft = "uml",
  },
  {
    "CRAG666/code_runner.nvim",
    config = true,
    event = "VeryLazy",
  },
  {
    "olrtg/nvim-emmet",
    event = "VeryLazy",
    keys = {
      cmd({
        key = l .. "e",
        action = "lua require('nvim-emmet').wrap_with_abbreviation()",
        desc = "Emmet expand",
      }),
      cmd({
        mode = "v",
        key = l .. "e",
        action = "lua require('nvim-emmet').wrap_with_abbreviation()",
        desc = "Emmet expand",
      }),
    },
  },
  {
    "vuki656/package-info.nvim",
    config = true,
    event = "VeryLazy",
  },
  {
    "max397574/colortils.nvim",
    config = true,
    event = "VeryLazy",
    keys = {
      cmd({
        key = l .. "cp",
        action = c("picker"),
        desc = "Color picker",
      }),
      cmd({
        key = l .. "cl",
        action = c("lighten"),
        desc = "Lighten",
      }),
      cmd({
        key = l .. "cd",
        action = c("darken"),
        desc = "Darken",
      }),
      cmd({
        key = l .. "cc",
        action = c("css"),
        desc = "CSS colors",
      }),
      cmd({
        key = l .. "cg",
        action = c("gradient"),
        desc = "Gradient",
      }),
    },
  },
  {
    "Equilibris/nx.nvim",
    event = "VeryLazy",
    config = function()
      return {
        nx_cmd_root = "nx",
        command_runner = require("nx.command-runners").terminal_cmd(),
        form_renderer = require("nx.form-renderers").telescope(),
        read_init = true,
      }
    end,
  },
  { "kkharji/sqlite.lua" },
}

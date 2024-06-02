return {
  { "aklt/plantuml-syntax",             event = "VeryLazy", },
  { "weirongxu/plantuml-previewer.vim", event = "VeryLazy" },
  { "CRAG666/code_runner.nvim",         config = true,      event = "VeryLazy" },
  {
    "olrtg/nvim-emmet",
    event = "VeryLazy",
    config = function()
      vim.keymap.set({ "n", "v" }, "<leader>xe", require("nvim-emmet").wrap_with_abbreviation)
    end,
  },
  { "bennypowers/nvim-regexplainer", event = "VeryLazy" },
  { "vuki656/package-info.nvim",     config = true,     event = "VeryLazy", },
  { "max397574/colortils.nvim",      config = true,     event = "VeryLazy", },
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

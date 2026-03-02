local l = "<leader>P"

return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    config = function(_, opts)
      require("snacks").setup(opts)
      Snacks.toggle.profiler():map(l .. "p")
      Snacks.toggle.profiler_highlights():map(l .. "h")
    end,
    opts = {
      bigfile = { enabled = true },
      debug = { enabled = true },
      dim = { enabled = true },
      image = { enabled = true },
      indent = {
        only_current = true,
        only_scope = true,
        animate = {
          enabled = true,
          style = "out",
          easing = "linear",
          duration = {
            step = 20,
            total = 500,
          },
        },
        scope = {
          underline = true,
          only_current = true,
        },
        chunk = {
          enabled = true,
        },
      },
      input = { enabled = true },
      notifier = { enabled = true },
      picker = { enabled = true }, -- has its own config file
      profiler = { enabled = true },
      rename = { enabled = true },
      scope = { enabled = true },
      quickfile = { enabled = true },

      animate = { enabled = false },
      dashboard = { enabled = false },
      gh = { enabled = false },
      scroll = { enabled = false },
      statuscolumn = { enabled = false },
      words = { enabled = false },
    },
    keys = {
      {
        l .. "s",
        function()
          Snacks.profiler.scratch()
        end,
        desc = "Profiler Scratch Buffer",
      },
      {
        l .. "i",
        function()
          Snacks.profiler.pick()
        end,
        desc = "Profiler Pick",
      },
    },
  },
}

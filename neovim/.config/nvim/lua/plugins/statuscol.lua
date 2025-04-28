return {
  {
    "luukvbaal/statuscol.nvim",
    config = function()
      local fold_width = 5
      local builtin = require("statuscol.builtin")

      require("statuscol").setup({
        relculright = true,
        ft_ignore = { "neo-tree" },
        segments = {
          {
            text = {
              function(args)
                local foldtext = builtin.foldfunc(args)
                return string.format("%-" .. tostring(fold_width) .. "s", foldtext or "")
              end,
              "  ",
            },
          },
          {
            sign = { name = { "diagnostic" }, namespace = { ".*" }, maxwidth = 2, colwidth = 2, foldclosed = true },
          },
          {
            sign = {
              name = { "neotest_*" },
              maxwidth = 1,
              colwidth = 1,
              auto = "",
              foldclosed = true,
            },
          },
          { sign = { name = { "Dap" }, maxwidth = 1, colwidth = 1, auto = false, foldclosed = true } },
          {
            sign = {
              name = { ".*" },
              namespace = { ".*" },
              maxwidth = 2,
              colwidth = 2,
              auto = false,
              foldclosed = true,
            },
          },
          {
            sign = {
              name = { "Marks*" },
              maxwidth = 1,
              colwidth = 1,
            },
          },
          {
            text = { builtin.lnumfunc, " " },
          },
          {
            sign = {
              namespace = { "gitsigns" },
              maxwidth = 1,
              colwidth = 1,
              auto = false,
            },
          },
        },
      })
    end,
  },
}

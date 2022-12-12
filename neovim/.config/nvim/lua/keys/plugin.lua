local wk = require("which-key")

wk.register({
  p = {
    name = "Misc Plugins",
    sr = { "<plug>SnipRun", "SnipRun" },
    sro = { "<plug>SnipRunOperator", "SnipRun" },
    v = { "<cmd>Vista!!<cr>", "Toggle Vista" },
  }
}, { prefix = "<leader>" })

wk.register({
  p = {
    name = "Misc Plugins",
    sr = { "<plug>SnipRun", "SnipRun" },
  }
}, { prefix = "<leader>", mode = "v" })

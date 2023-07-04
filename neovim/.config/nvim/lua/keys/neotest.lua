local wk = require("which-key")

wk.register({
  ["<leader>j"] = {
    name = "Run Tests",
    r = { "<cmd>lua require('neotest').run.run()<cr>", "Nearest" },
    f = {
      "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>",
      "Whole file",
    },
    d = {
      "<cmd>lua require('neotest').run.run({strategy = 'dap'})<cr>",
      "Debug",
    },
    s = {
      "<cmd>lua require('neotest').run.stop()<cr>",
      "Stop",
    },
    a = {
      "<cmd>lua require('neotest').run.attach()<cr>",
      "Attach",
    },
    w = {
      "<cmd>lua require('neotest').run.run({ jestCommand = 'jest --watch ' })<cr>",
      "Jest Watch",
    },
  },
})

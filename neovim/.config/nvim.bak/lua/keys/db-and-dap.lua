local wk = require("which-key")

local db = function(command)
  return "<cmd>DBUI" .. command .. "<cr>"
end

local dap = function(command)
  return "<cmd>lua require'dap'." .. command .. "()<cr>"
end

wk.register({
  d = {
    name = "Database, Debug and Test",
    b = {
      name = "DBUI",
      t = { db("Toggle"), "Toggle" },
      f = { db("FindBuffer"), "Find Buffer" },
      r = { db("RenameBuffer"), "Rename Buffer" },
      l = { db("LastQueryInfo"), "Last Query Info" },
    },
    g = {
      name = "Debug with DAP",
      c = { dap("continue"), "Continue" },
      u = { "<cmd>lua require('dapui').toggle()<cr>", "Toggle UI" },
      t = { dap("toggle_breakpoint"), "Toggle breakpoint" },
      T = {
        "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>",
        "Toggle breakpoint with condition",
      },
      o = { dap("step_over"), "Step over" },
      i = { dap("step_into"), "Step into" },
      ou = { dap("step_out"), "Step out" },
    },
    t = {
      name = "Test",
      r = { "<cmd>lua require('neotest').run.run()<cr>", "Nearest" },
      f = {
        "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>",
        "Whole file",
      },
      d = {
        "<cmd>lua require('neotest').run.run({strategy = 'dap'})<cr>",
        "Debug",
      },
      s = { "<cmd>lua require('neotest').run.stop()<cr>", "Stop" },
      a = { "<cmd>lua require('neotest').run.attach()<cr>", "Attach" },
      w = {
        "<cmd>lua require('neotest').run.run({ jestCommand = 'jest --watch ' })<cr>",
        "Jest Watch",
      },
    },
  },
}, { prefix = "<leader>" })

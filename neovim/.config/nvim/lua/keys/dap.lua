local wk = require("which-key")

local f = function(command)
  return "<cmd>lua require'dap'." .. command .. "()<cr>"
end

wk.register({
  dg = {
    name = "Debug with DAP",
    c = { f("continue"), "Continue" },
    u = { "<cmd>lua require('dapui').toggle()<cr>", "Toggle UI" },
    t = { f("toggle_breakpoint"), "Toggle breakpoint" },
    T = { "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>",
      "Toggle breakpoint with condition" },
    o = { f("step_over"), "Step over" },
    i = { f("step_into"), "Step into" },
    ou = { f("step_out"), "Step out" },
  }
}, { prefix = "<leader>" })

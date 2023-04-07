local wk = require("which-key")

local f = function(command)
  return "<esc><cmd>lua require('refactoring').refactor('" .. command .. "')<cr>"
end

wk.register({
  r = {
    name = "Refactoring",
    e = { f("Extract Function"), "Extract Function" },
    f = { f("Extract Function To File"), "Extract Function To File" },
    v = { f("Extract Variable"), "Extract Variable" },
    i = { f("Inline Variable"), "Inline Variable" },
  }
}, { prefix = "<leader>", mode = "v" })

wk.register({
  r = {
    name = "Refactoring",
    b = { f("Extract Block"), "Extract Block" },
    bf = { f("Extract Block To File"), "Extract Block To File" },
    i = { f("Inline Variable"), "Inline Variable" },
  }
}, { prefix = "<leader>" })

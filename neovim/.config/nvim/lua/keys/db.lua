local wk = require("which-key")

local f = function(command)
  return "<cmd>DBUI" .. command .. "<cr>"
end

wk.register({
  db = {
    name = "DBUI",
    t = { f("Toggle"), "Toggle" },
    f = { f("FindBuffer"), "Find Buffer" },
    r = { f("RenameBuffer"), "Rename Buffer" },
    l = { f("LastQueryInfo"), "Last Query Info" },
  }
}, { prefix = "<leader>" })

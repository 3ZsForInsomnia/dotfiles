local wk = require("which-key")

local f = function(command)
  return "<cmd>TroubleToggle " .. command .. "<cr>"
end

wk.register({
  t = {
    name = "View diagnostics",
    l = { f(""), "Toggle Diagnostics list" },
    w = { f("workspace_diagnostics"), "Show Workspace Diagnostics" },
    d = { f("document_diagnostics"), "Show Document Diagnostics" },
    q = { f("quickfix"), "Show diagnostics in Quickfix" },
    o = { f("loclist"), "Show diagnostics in loclist" },
  },
}, { prefix = "<leader>" })

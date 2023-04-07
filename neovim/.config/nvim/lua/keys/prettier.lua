local wk = require("which-key")

local f = function(command)
  return "<cmd>Prettier" .. command .. "<cr>"
end

wk.register({
  p = {
    name = "Prettier",
    r = { f(""), "Normal Prettier" },
    rc = { "<cmd>Prettier <cr> <bar> zM", "Runs Prettier and closes all folds" },
    ro = { "<cmd>Prettier <cr> <bar> zM <bar> zczA", "Runs Prettier and opens all folds at cursor" },
    rf = { f("Fragment"),
      "Formats only current selection, but does not preserve indentation (allows errors elsewhere in code)" },
    rt = { f("Partial"), "Formats the given selection, but preserves indentation (whole file must be valid)" }
  }
}, { prefix = "<leader>" })

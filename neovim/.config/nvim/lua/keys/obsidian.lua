local wk = require("which-key")

wk.register({
  o = {
    name = "Obsidian",
    t = { "<cmd>ObsidianToday<cr>", "Open today's note" },
    n = { ":ObsidianNew ", "Create new note" },
    q = { "<cmd>ObsidianQuickSwitch<cr>", "Open quick switcher" },
    i = { "<cmd>ObsidianTemplate<cr>", "Insert template selected" },
    o = {
      "<cmd>ObsidianOpen<cr>",
      "Open note in current buffer in Obsidian app",
    },
  },
  f = { o = { "<cmd>ObsidianSearch<cr>", "Search vault" } },
}, { prefix = "<leader>" })

-- This is here since it is mostly intended to be used with tables in Obsidian notes
wk.register({ t = { ":Tabularize /", "Tabularize text based on pattern" } }, { mode = "v" })

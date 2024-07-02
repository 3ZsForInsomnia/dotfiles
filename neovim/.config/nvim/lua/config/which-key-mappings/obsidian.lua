local wk = require("which-key")

wk.register({
  o = {
    name = "Obsidian",
    t = "Open today's note",
    n = "Create new note",
    q = "Open quick switcher",
    i = "Insert template selected",
    l = "Create link",
    f = "Follow link",
    o = "Open note in current buffer in Obsidian app",
    r = "Rename note",
    p = "Paste image from clipboard with name",
    e = "Extract visual selection to a new note",
    s = "Search notes",
  },
}, { prefix = "<leader>" })

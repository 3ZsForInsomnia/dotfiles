local wk = require("which-key")

wk.register({
  n = {
    name = "NvimTree",
    o = { "<cmd>NvimTreeToggle<cr>", "Open/Close" },
    f = { "<cmd>NvimTreeFindFile<cr>", "Find file" },
    t = { "<cmd>NvimTreeFindFileToggle<cr>", "Find file (and open if previously closed)" },
    c = { "<cmd>NvimTreeCollapse<cr>", "Collapse" },
    k = { "<cmd>NvimTreeCollapseKeepBuffers<cr>", "Collapse all but dirs of file in buffer" },
    p = { "<cmd>NvimTreeClipboard<cr>", "Clipboard" },
    b = { "<cmd>NvimTreeResize 70<cr>", "Make bigger" },
    s = { "<cmd>NvimTreeResize 45<cr>", "Make smaller" },
    r = { "<cmd>NvimTreeRefresh<cr>", "Refresh" },
  },
}, { prefix = "<leader>" })

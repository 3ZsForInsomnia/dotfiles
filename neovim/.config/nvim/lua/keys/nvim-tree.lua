local wk = require("which-key")

wk.register({
  n = {
    name = "NvimTree",
    t = { "<cmd>NvimTreeToggle<cr>", "Open/Close" },
    o = { "<cmd>NvimTreeFocus<cr>", "Focus on existing NvimTree buffer" },
    f = { "<cmd>NvimTreeFindFile<cr>", "Find file" },
    tf = { "<cmd>NvimTreeFindFileToggle<cr>", "Find file (and open if previously closed)" },
    c = { "<cmd>NvimTreeCollapse<cr>", "Collapse" },
    cb = { "<cmd>NvimTreeCollapseKeepBuffers<cr>", "Collapse all but dirs of file in buffer" },
    b = { "<cmd>NvimTreeClipboard<cr>", "Clipboard" },
    rb = { "<cmd>NvimTreeResize 70<cr>", "Make bigger" },
    rs = { "<cmd>NvimTreeResize 45<cr>", "Make smaller" },
    r = { "<cmd>NvimTreeRefresh<cr>", "Refresh" },
  },
}, { prefix = "<leader>" })

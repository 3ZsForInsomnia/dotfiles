local wk = require("which-key")

wk.register({
  p = {
    name = "Misc Plugins",
    sr = { "<plug>SnipRun", "SnipRun" },
    sro = { "<plug>SnipRunOperator", "SnipRun" },
    v = { "<cmd>Vista!!<cr>", "Toggle Vista" },
    t = { "<cmd>VimTrello<cr>", "Open Trello" },
    mb = { "<cmd>MarksListBuf<cr>", "View Marks in Buffer", },
    mg = { "<cmd>MarksListBuf<cr>", "View all marks", },
    b = { "<cmd>BookmarksListAll<cr>", "View all bookmarks", },
    ba = { ":BookmarksList ", "View bookmarks in group", },
    g = { "<cmd>DogeGenerate<cr>", "Generate docstring for whatever is under cursor" },
  },
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

wk.register({
  p = {
    name = "Misc Plugins",
    sr = { "<plug>SnipRun", "SnipRun" },
  }
}, { prefix = "<leader>", mode = "v" })

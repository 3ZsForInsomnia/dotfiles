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
}, { prefix = "<leader>" })

wk.register({
  p = {
    name = "Misc Plugins",
    sr = { "<plug>SnipRun", "SnipRun" },
  }
}, { prefix = "<leader>", mode = "v" })

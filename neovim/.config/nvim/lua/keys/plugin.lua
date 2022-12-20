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
    g = {
      name = "Generate docstring",
      f = { "<cmd>Neogen<cr>", "For the current function" },
      c = { "<cmd>Neogen class<cr>", "For the current class" },
      t = { "<cmd>Neogen type<cr>", "For the current type" },
    }
  }
}, { prefix = "<leader>" })

wk.register({
  p = {
    name = "Misc Plugins",
    sr = { "<plug>SnipRun", "SnipRun" },
  }
}, { prefix = "<leader>", mode = "v" })

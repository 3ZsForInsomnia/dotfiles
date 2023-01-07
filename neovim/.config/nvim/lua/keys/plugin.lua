local wk = require("which-key")

wk.register({
  p = {
    name = "Misc Plugins",
    v = { "<cmd>Vista!!<cr>", "Toggle Vista" },
    t = { "<cmd>VimTrello<cr>", "Open Trello" },
    g = { "<cmd>DogeGenerate<cr>", "Generate docstring for whatever is under cursor" },
    f = { "<cmd>Twilight<cr>", "Dim unused code (twilight)" },
    c = {
      name = "Color Utils",
      p = { "<cmd>Colortils picker<cword><cr>", "Picker" },
      l = { "<cmd>Colortils lighten<cword><cr>", "Lighten" },
      d = { "<cmd>Colortils darken<cword><cr>", "Darken" },
      c = { "<cmd>Colortils css<cword><cr>", "CSS colors" },
      g = { "<cmd>Colortils gradient<cword><cr>", "Gradient" },
    },
  },
  m = {
    name = "Marks",
    l = { "<cmd>MarksListBuf<cr>", "View Marks in Buffer in loclist" },
    q = { "<cmd>MarksQFListGlobal<cr>", "View all marks in qflist" },
  },
  b = {
    name = "Bookmarks",
    q = { "<cmd>BookmarksQFListAll<cr>", "View all bookmarks in qflist" },
    l = { "<cmd>BookmarksListAll<cr>", "View all bookmarks in loclist" },
    g = { ":BookmarksList ", "View bookmarks in group" },
  },
}, { prefix = "<leader>" })

wk.register({
  p = {
    name = "Misc Plugins",
    sr = { "<plug>SnipRun", "SnipRun" },
  }
}, { prefix = "<leader>", mode = "v" })

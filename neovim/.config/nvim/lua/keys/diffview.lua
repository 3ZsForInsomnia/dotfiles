local wk = require("which-key")

local f = function(command)
  return "<cmd>Diffview" .. command .. "<cr>"
end

wk.register({
  ['<leader>'] = {
    v = {
      name = "DiffView",
      o = {
        [''] = { f("Open"), "Open" },
        m = { f("Open origin/master"), "Open origin/master" },
        i = { f("Open origin/main"), "Open origin/main" },
        o = { ":DiffviewOpen origin/", "Open origin/${branch}" },
        h = { f("Open HEAD~"), "Open HEAD~${numberOfCommits}" }
      },
      c = { f("Close"), "Close" },
      t = { f("ToggleFiles"), "Toggle Files" },
    },
    c = {
      o = "Diffview Choose Ours",
      t = "Diffview Choose Theirs",
      b = "Diffview Choose Base",
    },
    dx = "Diffview delete conflict",
  },
  [']x'] = "Jump to next conflict marker",
  ['[x'] = "Jump to previous conflict marker",
})

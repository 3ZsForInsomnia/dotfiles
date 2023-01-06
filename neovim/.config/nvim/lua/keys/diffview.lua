local wk = require("which-key")

local f = function(command)
  return "<cmd>Diffview" .. command .. "<cr>"
end

wk.register({
  ['<leader>'] = {
    v = {
      name = "DiffView",
      o = { f("Open"), "Open" },
      ob = { f("Open"), "Open" },
      c = { f("Close"), "Close" },
      t = { f("ToggleFiles"), "Toggle Files" },
      om = { f("Open origin/master"), "Open origin/master" },
      oi = { f("Open origin/main"), "Open origin/main" },
      oo = { ":DiffviewOpen origin/", "Open origin/${branch}" },
      oh = { f("Open HEAD~"), "Open HEAD~${numberOfCommits}" }
    },
    co = "Diffview Choose Ours",
    ct = "Diffview Choose Theirs",
    cb = "Diffview Choose Base",
    dx = "Diffview delete conflict",
  },
  [']x'] = "Jump to next conflict marker",
  ['[x'] = "Jump to previous conflict marker",
})

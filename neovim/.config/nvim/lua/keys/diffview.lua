local wk = require("which-key")

local mainBranch = function()
  return string.gsub(vim.fn.system("git remote show origin | sed -n '/HEAD branch/s/.*: //p'"), '\n', '')
end

local f = function(command)
  return "<cmd>Diffview" .. command .. "<cr>"
end

wk.register({
  ['<leader>'] = {
    v = {
      name = "DiffView",
      o = {
        [''] = { f("Open"), "Open" },
        m = { function() print(f("Open origin/" .. mainBranch())) end, "Open origin/${mainBranchName}" },
        o = { ":DiffviewOpen origin/", "Open origin/${branch}" },
        h = { ":DiffviewOpen HEAD~n", "Open HEAD~${numberOfCommits}" }
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

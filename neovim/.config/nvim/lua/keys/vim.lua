local wk = require("which-key")

wk.register({
  ["<leader>"] = {
    l = {
      name = "Easy log",
      js = { "\"ayiwoconsole.log('<C-R>a:', <C-R>a);<Esc>", "Log word under cursor (js)" },
      lua = { "\"ayiwoprint('<C-R>a:', vim.inspect(<C-R>a))<Esc>", "Log word under cursor (lua)" },
    },
    s = {
      name = "Session",
      s = { "<cmd>lua SaveSessionByName()<cr>", "Save with name" },
      sa = { "<cmd>lua SaveSession('aliases')<cr>", "Save aliases" },
      st = { "<cmd>lua SaveSession('temp')<cr>", "Save temp" },
      r = { "<cmd>lua RestoreSessionByName()<cr>", "Restore by name" },
      ra = { "<cmd>lua RestoreSession('aliases')<cr>", "Restore aliases" },
      rt = { "<cmd>lua RestoreSession('temp')<cr>", "Restore temp" },
      d = { "<cmd>lua DeleteSessionByName()<cr>", "Delete named" },
    },
    z = {
      name = "Personal",
      ws = { "<cmd>w<cr><bar><cmd>source %<cr>", "Write and source current file" },
      ['%'] = { "<cmd>source %<cr>", "Source current file" },
      ['%i'] = { "<cmd>source ~/.config/nvim/init.vim<cr>", "Source init.vim" },
      z = { "<cmd>w<cr>", "Write file" },
      ta = { "<cmd>set number!<cr>", "Toggle absolute line numbers" },
      tr = { "<cmd>set relativenumber!<cr>", "Toggle relative line numbers" },
      a = { "<cmd>set number<cr>", "Set absolute line numbers" },
      r = { "<cmd>set relativenumber<cr>", "Set relative line numbers" },
    },
    ts = { ":ts", "Go to tag by name" },
    ['dm!'] = { "<cmd>delmarks!<cr>", "Delete all marks" },
    [','] = { "<cmd>nohlsearch<cr>", "Stop highlighting search results" },
  },
  ['<C-[>'] = { "<cmd>pop<cr>", "Pop entry off tag stack" },
})
wk.register({
  ['<C-c>'] = { "<esc>`^", "Escape and keep location" },
}, { mode = 'i' })
wk.register({
  ['<esc>'] = { "<C-\\><C-n>", "Escape but for terminal mode" },
}, { mode = 't' })

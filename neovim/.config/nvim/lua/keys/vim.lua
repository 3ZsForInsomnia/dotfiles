local wk = require("which-key")

wk.register({
  ["<leader>"] = {
    z = {
      name = "Personal",
      ws = { "<cmd>w<cr><bar><cmd>source %<cr>", "Write and source current file" },
      ['%'] = { "<cmd>source %<cr>", "Source current file" },
      ['%i'] = { "<cmd>source ~/.config/nvim/init.vim<cr>", "Source init.vim" },
      z = { "<cmd>w<cr>", "Write file" },
      tabs = { "<cmd>set number!<cr>", "Toggle absolute line numbers" },
      trel = { "<cmd>set relativenumber!<cr>", "Toggle relative line numbers" },
      abs = { "<cmd>set number<cr>", "Set absolute line numbers" },
      rel = { "<cmd>set relativenumber<cr>", "Set relative line numbers" },
      s = {
        s = { ":lua SaveSession('')<left><left>", "Save named session" },
        sa = { ":lua SaveSession('aliases')<cr>", "Save aliases session" },
        st = { ":lua SaveSession('temp')<cr>", "Save temp session" },
        r = { "<cmd>lua RestoreSessionByName()<cr>", "Restore session by name" },
        rb = { ":lua RestoreSession('')<left><left>", "Restore named session" },
        ra = { ":lua RestoreSession('aliases')<cr>", "Restore aliases session" },
        rt = { ":lua RestoreSession('temp')<cr>", "Restore temp session" },
        d = { "<cmd>lua DeleteSessionByName()<cr>", "Delete named session" },
        db = { ":lua DeleteSession('')<left><left>", "deleted named session" },
      },
      ljs = { "\"ayiwoconsole.log('<C-R>a:', <C-R>a);<Esc>", "Log word under cursor (js)" },
    },
    ts = { ":ts", "Go to tag by name" },
    dm = { ":delmarks ", "Delete marks" },
    ['dm!'] = { "<cmd>delmarks!<cr>", "Delete all marks" },
    [','] = { "<cmd>nohlsearch<cr>", "Stop highlighting search results" },
  },
  ['<C-[>'] = { "<cmd>pop<cr>", "Pop entry off tag stack" },
  [',,'] = { "zc", "Close current fold" },
  ['..'] = { "zo", "Open current fold" },
})
wk.register({
  ['<C-c>'] = { "<esc>`^", "Escape and keep location" },
}, { mode = 'i' })
wk.register({
  ['<esc>'] = { "<C-\\><C-n>", "Escape but for terminal mode" },
}, { mode = 't' })

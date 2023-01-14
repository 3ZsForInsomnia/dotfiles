local wk = require("which-key")

_G.logThis = function(str)
  local ft = vim.bo.filetype
  str = string.gsub(str, "%s+", "")

  if ft == 'javascript' or ft == 'typescript' then
    return 'console.log("' .. str .. '", ' .. str .. ');'
  elseif ft == 'lua' then
    return 'print("' .. str .. '", vim.inspect(' .. str .. '))'
  end

  return 'echo ' .. str
end

wk.register({
  ["<leader>"] = {
    p = { "'\"+p", "Paste from clipboard" },
    y = { "'\"+y", "Copy to clipboard" },
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
      l = { "vaw\"qyo<c-r>=luaeval('logThis(vim.fn.getreg(\"q\"))')<cr><esc><up>",
        "Insta-log anything while in normal mode" },
    },
    ts = { ":ts", "Go to tag by name" },
    ['dm!'] = { "<cmd>delmarks!<cr>", "Delete all marks" },
    [','] = { "<cmd>nohlsearch<cr>", "Stop highlighting search results" },
  },
  ['<C-[>'] = { "<cmd>pop<cr>", "Pop entry off tag stack" },
  ['<C-y>'] = { "10<C-y>", "Scroll up 10 lines without moving cursor" },
  ['<C-e>'] = { "10<C-e>", "Scroll down 10 lines without moving cursor" },
})

wk.register({
  ['<C-c>'] = { "<esc>`^", "Escape and keep location" },
  ['<C-l>'] = { "<esc>vaw\"qyo<c-r>=luaeval('logThis(vim.fn.getreg(\"q\"))')<cr><up>",
    "Insta-log anything while in insert mode" },
}, { mode = 'i' })

wk.register({
  ['<leader>'] = {
    p = { "'\"+p", "Paste from clipboard" },
    y = { "'\"+y", "Copy to clipboard" },
  },
  ['<C-y>'] = { "10<C-y>", "Scroll up 10 lines without moving cursor" },
  ['<C-e>'] = { "10<C-e>", "Scroll down 10 lines without moving cursor" },
}, { mode = 'v' })

wk.register({
  ['<esc>'] = { "<C-\\><C-n>", "Escape but for terminal mode" },
}, { mode = 't' })

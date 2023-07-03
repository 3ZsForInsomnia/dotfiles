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
    pc = { "'\"+p", "Paste from clipboard" },
    yc = { "'\"+y", "Copy to clipboard" },
    s = {
      name = "Session",
      s = { "<cmd>lua SaveSessionByName()<cr>", "Save with name" },
      sa = { "<cmd>lua SaveSession('aliases')<cr>", "Save aliases" },
      st = { "<cmd>lua SaveSession('temp')<cr>", "Save temp" },
      r = { "<cmd>lua RestoreSessionByName()<cr>", "Restore by name" },
      ra = { "<cmd>lua RestoreSession('aliases')<cr>", "Restore aliases" },
      rt = { "<cmd>lua RestoreSession('temp')<cr>", "Restore temp" },
      d = { "<cmd>lua DeleteSessionByName()<cr>", "Delete named" }
    },
    z = {
      name = "Personal",
      y = {
        "<cmd>let @+ = expand('%')<cr>",
        "Copy filename + path to clipboard"
      },
      ws = {
        "<cmd>w<cr><bar><cmd>source %<cr>",
        "Write and source current file"
      },
      ['%'] = { "<cmd>source %<cr>", "Source current file" },
      ['%i'] = {
        "<cmd>source ~/.config/nvim/init.vim<cr>", "Source init.vim"
      },
      z = { "<cmd>w<cr>", "Write file" },
      ta = { "<cmd>set number!<cr>", "Toggle absolute line numbers" },
      tr = {
        "<cmd>set relativenumber!<cr>", "Toggle relative line numbers"
      },
      a = { "<cmd>set number<cr>", "Set absolute line numbers" },
      r = { "<cmd>set relativenumber<cr>", "Set relative line numbers" },
      l = {
        "vaw\"qyo<c-r>=luaeval('logThis(vim.fn.getreg(\"q\"))')<cr><esc><up>",
        "Insta-log anything while in normal mode"
      }
    },
    ts = { ":ts", "Go to tag by name" },
    ['dm!'] = { "<cmd>delmarks!<cr>", "Delete all marks" },
    [','] = { "<cmd>nohlsearch<cr>", "Stop highlighting search results" }
  },
  ['<C-'] = {
    ['[>'] = { "<cmd>pop<cr>", "Pop entry off tag stack" },
    ['y>'] = { "10<C-y>", "Scroll up 10 lines without moving cursor" },
    ['e>'] = { "10<C-e>", "Scroll down 10 lines without moving cursor" },
    ["d>"] = { "<C-d>zz", "Scroll and center text on screen" },
    ["u>"] = { "<C-u>zz", "Scroll and center text on screen" }
  },
  ["<M-d>"] = { "\"_d", "Delete but preserve yanked register" },
})

wk.register({
  M = {
    name = "Named Bookmarks",
    ['0'] = { "<Plug>(Marks-next-bookmark0)", "Good" },
    ['9'] = { "<Plug>(Marks-next-bookmark9)", "Investigation path" },
    ['8'] = { "<Plug>(Marks-next-bookmark8)", "Confusion/question" },
    ['7'] = { "<Plug>(Marks-next-bookmark7)", "Bad" },
    ['6'] = { "<Plug>(Marks-next-bookmark6)", "Home/current workspace" },
    ['5'] = { "<Plug>(Marks-next-bookmark5)", "Information" }
  }
})

wk.register({
  ['<C-'] = {
    ['c>'] = { "<esc>`^", "Escape and keep location" },
    ['l>'] = {
      "<esc>vaw\"qyo<c-r>=luaeval('logThis(vim.fn.getreg(\"q\"))')<cr><up>",
      "Insta-log anything while in insert mode"
    },
    ["j>"] = {
      "<Plug>luasnip-next-choice",
      "Cycle to next luasnip choicenode option"
    },
    ["k>"] = {
      "<Plug>luasnip-prev-choice",
      "Cycle to prev luasnip choicenode option"
    },
    ["e>"] = {
      "<Plug>luasnip-expand-snippet",
      "Luasnip expand snippet under cursor"
    },
    ["s>"] = {
      "<cmd>lua require('luasnip.extras.select_choice')()<cr>",
      "Open select popup for luasnip choice"
    }
  }
}, { mode = 'i' })

wk.register({
  ['<leader>'] = {
    pc = { "'\"+p", "Paste from clipboard" },
    yc = { "'\"+y", "Copy to clipboard" }
  },
  ['<C-'] = {
    ['y>'] = { "10<C-y>", "Scroll up 10 lines without moving cursor" },
    ['e>'] = { "10<C-e>", "Scroll down 10 lines without moving cursor" },
    ["d>"] = { "\"_d", "Delete but preserve yanked register" },
    ["s>"] = {
      "<cmd>lua require('luasnip.extras.select_choice')()<cr>",
      "Open select popup for luasnip choice"
    }
  }
}, { mode = 'v' })

wk.register({ ['<esc>'] = { "<C-\\><C-n>", "Escape but for terminal mode" } },
  { mode = 't' })

wk.register({
  ['<C-'] = {
    ["j>"] = {
      "<Plug>luasnip-next-choice",
      "Cycle to next luasnip choicenode option"
    },
    ["k>"] = {
      "<Plug>luasnip-prev-choice",
      "Cycle to prev luasnip choicenode option"
    },
    ["e>"] = {
      "<Plug>luasnip-expand-snippet",
      "Luasnip expand snippet under cursor"
    },
    ["s>"] = {
      "<cmd>lua require('luasnip.extras.select_choice')()<cr>",
      "Open select popup for luasnip choice"
    }
  }
}, { mode = 's' })

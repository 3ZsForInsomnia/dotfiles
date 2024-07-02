-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

local v = vim
local a = v.api
local c = v.cmd
local h = a.nvim_set_hl
local ag = a.nvim_create_augroup
local au = a.nvim_create_autocmd

-- Mode specific MsgArea, CursorLineNr and LineNr formatting
a.nvim_create_autocmd("ModeChanged", {
  callback = function()
    local mode = v.api.nvim_get_mode().mode
    local colorsForCursorLine = {
      ["i"] = "#00ff00",
      ["n"] = "#00ffff",
      ["c"] = "#e0af68",
      ["v"] = "#c678dd",
      ["V"] = "#c678dd",
      [""] = "#c678dd",
    }

    h(0, "CursorLineNr", {
      foreground = colorsForCursorLine[mode] or "#666666",
      bold = true,
    })

    if mode == "c" then
      h(0, "MsgArea", {
        foreground = colorsForCursorLine[mode],
      })
      h(0, "LineNr", {
        foreground = colorsForCursorLine[mode],
      })
    else
      h(0, "MsgArea", {
        foreground = "#cccccc",
      })
      h(0, "LineNr", {
        foreground = "#666666",
      })
    end
  end,
})

ag("__formatter__", { clear = true })
au("BufWritePost", {
  group = "__formatter__",
  command = ":FormatWrite",
})

au("BufWritePost", {
  pattern = "*",
  callback = function()
    require("lint").try_lint()
  end,
})

au({ "BufWinEnter", "WinEnter" }, {
  pattern = "term://*",
  command = "setlocal filetype=terminal",
})
ag("term_open_insert", {})
au({ "TermOpen" }, {
  group = "term_open_insert",
  pattern = "*",
  command = [[
      startinsert
      setlocal nonumber norelativenumber nospell signcolumn=no noruler
    ]],
})

au({ "User" }, {
  pattern = "TelescopePreviewerLoaded",
  command = "setlocal wrap",
})

c([[
  function! RemoveQFItem()
    let curqfidx = line('.') - 1
    let qfall = getqflist()
    call remove(qfall, curqfidx)
    call setqflist(qfall, 'r')
    :copen
  endfunction
  :command! RemoveQFItem :call RemoveQFItem()
]])
au("FileType", {
  pattern = "qf",
  command = "map <buffer> dd <cmd>RemoveQFItem<cr>",
})

au("FileType", {
  pattern = "qf",
  callback = function()
    vim.opt_local.buflisted = false
  end,
})

c([[
  function! E()
    function! A(timer)
      echo ""
    endfunction
    call timer_start(15000, 'A')
  endfunction
  :command! E :call E()
]])
au("CursorHold", {
  pattern = "*",
  command = "call E()",
})

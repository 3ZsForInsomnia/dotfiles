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
  callback = function()
    local buf_name = v.api.nvim_buf_get_name(0)
    if not string.match(buf_name, "neotest") then
      v.cmd.startinsert()
      v.opt_local.ruler = false
    end
  end,
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
    v.opt_local.buflisted = false
  end,
})

au({ "BufNewFile", "BufRead" }, {
  pattern = "*.zsh",
  callback = function()
    v.bo.filetype = "sh"
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

_G.extended_search_count = function()
  if vim.v.hlsearch == 0 then
    -- Clear existing extmarks if highlighting is off
    local bufnr = a.nvim_get_current_buf()
    local ns_id = a.nvim_create_namespace("search_status_virtual_text")
    a.nvim_buf_clear_namespace(bufnr, ns_id, 0, -1)
    return
  end

  local shortmess_str = vim.o.shortmess

  if not shortmess_str:find("S") then
    return
  end

  local search_count_options = { maxcount = 100000, timeout = 500 }
  local sinfo = vim.fn.searchcount(search_count_options)

  local search_stat = sinfo.incomplete > 0 and "[?/?]"
    or sinfo.total > 0 and ("[%s/%s]"):format(sinfo.current, sinfo.total)
    or nil

  if search_stat ~= nil then
    local bufnr = a.nvim_get_current_buf()
    local line = a.nvim_win_get_cursor(0)[1] - 1

    local ns_id = a.nvim_create_namespace("search_status_virtual_text")
    a.nvim_buf_clear_namespace(bufnr, ns_id, 0, -1)

    a.nvim_buf_set_extmark(bufnr, ns_id, line, -1, {
      virt_text = { { search_stat, "Search" } },
      virt_text_pos = "eol",
    })
  end
end

a.nvim_exec(
  [[
  augroup UpdateSearchCount
    autocmd!
    autocmd CmdlineEnter /,\? lua extended_search_count()
    autocmd CmdlineLeave /,\? lua extended_search_count()
    autocmd CursorMoved,CursorMovedI * lua extended_search_count()
  augroup END
]],
  false
)

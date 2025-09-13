-- Terminal-specific autocmds
local v = vim
local a = v.api
local au = a.nvim_create_autocmd
local ag = a.nvim_create_augroup

-- Set terminal filetype for terminal buffers
au({ "BufWinEnter", "WinEnter" }, {
  pattern = "term://*",
  command = "setlocal filetype=terminal",
})

-- Auto-enter insert mode in terminal (except neotest)
ag("term_open_insert", { clear = true })
au("TermOpen", {
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
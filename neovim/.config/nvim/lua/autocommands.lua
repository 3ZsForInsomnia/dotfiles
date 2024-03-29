local ag = vim.api.nvim_create_augroup
local au = vim.api.nvim_create_autocmd

au("BufWritePost", {
	pattern = "*",
	command = "FormatWrite",
})

au("BufWritePost", {
	pattern = "*",
	callback = function()
		require("lint").try_lint()
	end,
})

au("TextYankPost", {
	pattern = "*",
	command = "lua vim.highlight.on_yank({timeout=333})",
})

au({ "BufWinEnter", "WinEnter" }, {
	pattern = "term://*",
	command = "setlocal filetype=zsh",
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

vim.cmd([[
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

vim.cmd([[
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

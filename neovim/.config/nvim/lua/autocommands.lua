local ag = vim.api.nvim_create_augroup
local au = vim.api.nvim_create_autocmd

au('TextYankPost',
  {
    pattern = "*",
    command = "lua vim.highlight.on_yank({timeout=333})"
  }
)

au(
  { "BufWinEnter", "WinEnter" },
  {
    pattern = "term://*",
    command = "setlocal filetype=zsh",
  }
)
ag('term_open_insert', {})
au(
  { "TermOpen" },
  {
    group = 'term_open_insert',
    pattern = '*',
    command = [[
      startinsert
      setlocal nonumber norelativenumber nospell signcolumn=no noruler
    ]]
  }
)

au(
  { "User" },
  {
    pattern = "TelescopePreviewerLoaded",
    command = "setlocal wrap",
  }
)

au('FileType', {
  pattern = 'qf',
  callback = function()
    vim.opt_local.buflisted = false
  end,
})
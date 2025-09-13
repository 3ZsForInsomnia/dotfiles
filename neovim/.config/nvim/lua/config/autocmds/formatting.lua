-- Formatting and linting autocmds
local v = vim
local a = v.api
local au = a.nvim_create_autocmd
local ag = a.nvim_create_augroup

-- Auto-format on save
ag("__formatter__", { clear = true })
au("BufWritePost", {
  group = "__formatter__",
  command = ":FormatWrite",
})

-- Auto-lint on save
au("BufWritePost", {
  pattern = "*",
  callback = function()
    require("lint").try_lint()
  end,
})
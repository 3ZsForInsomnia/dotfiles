local v = vim
local a = v.api
local au = a.nvim_create_autocmd

au("FileType", {
  pattern = "dbui",
  callback = function()
    v.defer_fn(function()
      v.opt_local.number = true
      v.opt_local.relativenumber = true
    end, 0)
  end,
})

au({ "BufNewFile", "BufRead" }, {
  pattern = "*.zsh",
  callback = function()
    v.bo.filetype = "sh"
  end,
})

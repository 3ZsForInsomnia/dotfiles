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

au("FileType", {
  pattern = {
    "bash",
    "zsh",
    "css",
    "scss",
    "html",
    "javascript",
    "typescript",
    "javascriptreact",
    "typescriptreact",
    "python",
    "go",
    "sql",
    "json",
    "markdown",
    "lua",
  },
  callback = function()
    local ft = vim.bo.filetype
    if ft and ft ~= "" then
      require("luasnip.loaders.from_vscode").lazy_load({
        include = { ft },
      })
    end
  end,
})

local M = {}

local f = function(filetype)
  return require("formatter.filetypes." .. filetype)
end

M.setup = function()
  require("formatter").setup({
    logging = true,
    log_level = vim.log.levels.WARN,
    filetype = {
      lua = { require("formatter.filetypes.lua").stylua },
      css = { f("css").eslint_d, f("css").prettierd },
      scss = { f("css").eslint_d, f("css").prettierd },
      graphql = { f("graphql").prettierd },
      html = { f("html").prettierd },
      json = { f("json").prettierd },
      markdown = { f("markdown").prettierd },
      yaml = { f("yaml").prettierd },
      sh = { f("sh").shfmt },
      sql = { f("sql").pgformat },
      java = { f("java").clangformat },
      javascript = { f("javascript").eslint_d, f("javascript").prettierd },
      javascriptreact = {
        f("javascriptreact").eslint_d,
        f("javascriptreact").prettierd,
      },
      typescript = { f("typescript").eslint_d, f("typescript").prettierd },
      typescriptreact = {
        f("typescriptreact").eslint_d,
        f("typescriptreact").prettierd,
      },
      python = { f("python").black, f("python").isort },
    },
  })
end

return M

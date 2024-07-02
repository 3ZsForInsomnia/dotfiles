return {
  {
    "mhartington/formatter.nvim",
    config = function()
      require("formatter").setup({
        logging = false,
        log_level = vim.log.levels.DEBUG,
        filetype = {
          lua = { require("formatter.filetypes.lua").stylua },
          css = {
            require("formatter.filetypes.css").prettierd,
            require("formatter.filetypes.css").stylelint,
          },
          graphql = { require("formatter.filetypes.graphql").prettierd },
          html = { require("formatter.filetypes.html").prettierd },
          json = { require("formatter.filetypes.json").prettierd },
          markdown = { require("formatter.filetypes.markdown").prettierd },
          yaml = { require("formatter.filetypes.yaml").prettierd },
          sh = { require("formatter.filetypes.sh").shfmt },
          sql = { require("formatter.filetypes.sql").sqlformat },
          java = { require("formatter.filetypes.java").google_java_format },
          javascript = {
            require("formatter.filetypes.javascript").eslint_d,
            require("formatter.filetypes.javascript").prettierd,
          },
          javascriptreact = {
            require("formatter.filetypes.javascript").eslint_d,
            require("formatter.filetypes.javascript").prettierd,
          },
          typescript = {
            require("formatter.filetypes.typescript").eslint_d,
            require("formatter.filetypes.typescript").prettierd,
          },
          typescriptreact = {
            require("formatter.filetypes.typescript").eslint_d,
            require("formatter.filetypes.typescript").prettierd,
          },
          python = {
            require("formatter.filetypes.python").black,
            require("formatter.filetypes.python").isort,
          },
        },
      })
    end,
  },
}

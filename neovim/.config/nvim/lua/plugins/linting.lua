return {
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      local lint = require("lint")

      lint.linters.golangcilint = {
        name = "golangcilint",
        parser = lint.linters.golangcilint.parser,
        cmd = lint.linters.golangcilint.cmd,
      }

      lint.linters_by_ft = {
        css = { "stylelint" },
        go = { "golangcilint" },
        javascript = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        json = { "jsonlint" },
        lua = { "luacheck" },
        -- markdown = { "markdownlint" },
        python = { "ruff" },
        scss = { "stylelint" },
        sh = { "shellcheck" },
        typescript = { "eslint_d" },
        typescriptreact = { "eslint_d" },
        yaml = { "yamllint" },
        -- zsh = { "shellcheck" },
      }
    end,
  },
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    config = function()
      local conform = require("conform")

      conform.setup({
        formatters = {
          golangcilint = {
            args = { "run", "--config=golangci.ci.yaml" },
          },
        },
        formatters_by_ft = {
          css = { "stylelint" },
          go = { "golangcilint" },
          javascript = { "eslint_d" },
          javascriptreact = { "eslint_d" },
          json = { "jsonlint" },
          lua = { "luacheck" },
          python = { "ruff" },
          scss = { "stylelint" },
          -- sh = { "shfmt" },
          typescript = { "eslint_d" },
          typescriptreact = { "eslint_d" },
          -- yaml = { "yamllint" },
          zsh = { "shfmt" },
        },
        format_on_save = {
          timeout_ms = 500,
          lsp_fallback = true,
        },
      })
    end,
  },
}

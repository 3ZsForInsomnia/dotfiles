return {
  {
    "mfussenegger/nvim-lint",
    config = function()
      require("lint").linters_by_ft = {
        css = { "stylelint" },
        go = { "golangcilint" },
        javascript = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        json = { "jsonlint" },
        lua = { "luacheck" },
        markdown = { "markdownlint" },
        python = { "flake8" },
        scss = { "stylelint" },
        sh = { "shellcheck" },
        typescript = { "eslint_d" },
        typescriptreact = { "eslint_d" },
        yaml = { "yamllint" },
        zsh = { "shellcheck" },
      }
    end,
  },
}

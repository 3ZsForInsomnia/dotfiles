return {
  {
    "mfussenegger/nvim-lint",
    config = function()
      require("lint").linters_by_ft = {
        javascript = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        typescript = { "eslint_d" },
        typescriptreact = { "eslint_d" },
        zsh = { "shellcheck" },
        sh = { "shellcheck" },
        yaml = { "yamllint" },
        css = { "stylelint" },
        scss = { "stylelint" },
        markdown = { "markdownlint" },
        lua = { "luacheck" },
        json = { "jsonlint" },
        python = { "flake8" },
      }
    end,
  },
}

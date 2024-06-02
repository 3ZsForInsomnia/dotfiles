local esl = { "eslint_d" }

return {
  {
    "mfussenegger/nvim-lint",
    config = function()
      local lint = require("lint")

      lint.linters_by_ft = {
        javascript = esl,
        javascriptreact = esl,
        typescript = esl,
        typescriptreact = esl,
        zsh = { "shellcheck" },
        sh = { "shellcheck" },
        yaml = { "yamllint" },
        css = { "stylelint" },
        scss = { "stylelint" },
        markdown = { "markdownlint" },
        lua = { "luacheck" },
        json = { "jsonlint" },
        python = { "flake8" },
        -- yaml = { "yamllint", sp },
        -- css = { "stylelint", sp },
        -- scss = { "stylelint", sp },
        -- markdown = { "markdownlint", sp },
        -- lua = { "luacheck", sp },
        -- json = { "jsonlint", sp },
        -- python = { "flake8", sp },
      }
    end,
  },
}

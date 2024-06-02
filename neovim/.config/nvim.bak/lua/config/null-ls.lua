local M = {}

function M.setup()
  local null_ls = require("null-ls")

  null_ls.setup({
    sources = {
      null_ls.builtins.code_actions.eslint_d,
      null_ls.builtins.code_actions.refactoring,
      null_ls.builtins.code_actions.gomodifytags,
      -- null_ls.builtins.code_actions.gitsigns,
      -- null_ls.builtins.code_actions.ts_node_action,
      -- require("typescript.extensions.null-ls.code-actions"),

      null_ls.builtins.diagnostics.eslint_d,
      null_ls.builtins.diagnostics.checkstyle.with({
        extra_args = { "-c", "/google_checks.xml" }, -- or "/sun_checks.xml" or path to self written rules
      }),
      null_ls.builtins.diagnostics.flake8,
      null_ls.builtins.diagnostics.golangci_lint,
      null_ls.builtins.diagnostics.luacheck,
      null_ls.builtins.diagnostics.markdownlint,
      null_ls.builtins.diagnostics.tsc,
      null_ls.builtins.diagnostics.sqlfluff.with({
        extra_args = { "--dialect", "mysql" }, -- change to your dialect
      }),
      null_ls.builtins.diagnostics.stylelint,
      null_ls.builtins.diagnostics.zsh,
      null_ls.builtins.diagnostics.pylint.with({
        diagnostics_postprocess = function(diagnostic)
          diagnostic.code = diagnostic.message_id
        end,
      }),

      null_ls.builtins.formatting.google_java_format,
      null_ls.builtins.formatting.lua_format,
      null_ls.builtins.formatting.gofumpt,
      null_ls.builtins.formatting.goimports,
      null_ls.builtins.formatting.autoflake,
      null_ls.builtins.formatting.markdown_toc, -- add <!-- toc --> to *.md to trigger
      null_ls.builtins.formatting.mdformat,
      null_ls.builtins.formatting.prettierd,
      null_ls.builtins.formatting.stylelint,
      null_ls.builtins.formatting.sql_formatter,
      null_ls.builtins.formatting.stylua,
      null_ls.builtins.formatting.sqlfluff.with({
        extra_args = { "--dialect", "mysql" }, -- change to your dialect
      }),
      null_ls.builtins.formatting.black.with({ extra_args = { "--line-length=100" } }),
      null_ls.builtins.formatting.isort,

      null_ls.builtins.hover.dictionary,
      null_ls.builtins.hover.printenv,
    },
  })
end

return M

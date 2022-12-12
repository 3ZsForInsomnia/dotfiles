local null_ls = require("null-ls")

null_ls.setup({
  sources = {
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.diagnostics.eslint,
    null_ls.builtins.code_actions.refactoring,
    null_ls.builtins.diagnostics.checkstyle.with({
      extra_args = { "-c", "/google_checks.xml" }, -- or "/sun_checks.xml" or path to self written rules
    }),
    null_ls.builtins.diagnostics.flake8,
    null_ls.builtins.diagnostics.luacheck,
    null_ls.builtins.diagnostics.markdownlint,
    null_ls.builtins.diagnostics.tsc,
    null_ls.builtins.formatting.google_java_format,
    null_ls.builtins.formatting.lua_format,
    null_ls.builtins.formatting.markdown_toc,
    null_ls.builtins.formatting.prettierd,
    null_ls.builtins.formatting.sql_formatter,
    null_ls.builtins.hover.dictionary,
  },
})

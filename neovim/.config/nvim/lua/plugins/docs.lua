local merge = function(t1, t2)
  for i = 1, #t2 do
    t1[#t1 + 1] = t2[i]
  end
  return t1
end

local js = { "ramda", "lodash-4", "node", "date_fns", "jest", "rxjs" }
local react = merge({ "react", "react_router", "tailwindcss", "html" }, js)

return {
  -- {
  --   "luckasRanarison/nvim-devdocs",
  --   cmd = { "DevdocsOpen", "DevdocsFetch", "DevdocsInstall" },
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --     "nvim-telescope/telescope.nvim",
  --     "nvim-treesitter/nvim-treesitter",
  --   },
  --   opts = {
  --     ensure_installed = {
  --       "angular",
  --       "angular-16",
  --       "axios",
  --       "bash",
  --       "css",
  --       "cypress",
  --       "date_fns",
  --       "docker",
  --       "eslint",
  --       "fastapi",
  --       "git",
  --       "go",
  --       "html",
  --       "http",
  --       "i3",
  --       "javascript",
  --       "jest",
  --       "jq",
  --       "kubernetes",
  --       "kubectl",
  --       "lodash-4",
  --       "lua-5.1",
  --       "markdown",
  --       "nextjs",
  --       "nginx",
  --       "node",
  --       "node-20_lts",
  --       "npm",
  --       "playwright",
  --       "postgresql-11",
  --       "prettier",
  --       "python-3.12",
  --       "ramda",
  --       "react",
  --       "react_router",
  --       "rxjs",
  --       "sass",
  --       "tailwindcss",
  --       "typescript",
  --     },
  --     filetypes = {
  --       scss = { "sass", "css", "tailwindcss" },
  --       javascript = merge({ "node", "javascript", "tailwindcss", "jest" }, js),
  --       typescript = merge({ "node", "javascript", "typescript", "tailwindcss", "jest" }, js),
  --       javascriptreact = merge({ "node", "javascript", "react", "tailwindcss", "jest" }, react),
  --       typescriptreact = merge({ "node", "javascript", "typescript", "react", "tailwindcss", "jest" }, react),
  --       css = { "tailwindcss", "css" },
  --     },
  --     previewer_cmd = "glow",
  --   },
  -- },
}

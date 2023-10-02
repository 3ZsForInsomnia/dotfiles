local M = {}

local f = function(filetype)
	return require("formatter.filetypes." .. filetype)
end

local pe = function(filetype)
	return { f(filetype).prettierd, f(filetype).eslint_d }
end

M.setup = function()
	require("formatter").setup({
		logging = true,
		log_level = vim.log.levels.WARN,
		filetype = {
			lua = { require("formatter.filetypes.lua").stylua },
			css = { pe("css") },
			scss = { pe("css") },
			graphql = { f("graphql").prettierd },
			html = { f("html").prettierd },
			json = { f("json").prettierd },
			markdown = { f("markdown").prettierd },
			yaml = { f("yaml").prettierd },
			sh = { f("sh").shfmt },
			sql = { f("sql").pgformat },
			java = { f("java").clangformat },
			javascript = { pe("javascript") },
			javascriptreact = { pe("javascriptreact") },
			typescript = { pe("typescript") },
			typescriptreact = { pe("typescriptreact") },
			python = { f("python").black, f("python").isort },
		},
	})
end

return M

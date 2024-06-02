local M = {}

local eslint_d_caching = function()
	local util = require("formatter.util")
	return {
		exe = "eslint_d",
		args = {
			"--stdin",
			"--stdin-filename",
			util.escape_path(util.get_current_buffer_file_path()),
			"--fix-to-stdout",
			"--cache",
		},
		stdin = true,
		try_node_modules = true,
	}
end

M.setup = function()
	require("formatter").setup({
		logging = true,
		log_level = vim.log.levels.WARN,
		filetype = {
			lua = { require("formatter.filetypes.lua").stylua },
			css = { require("formatter.filetypes.css").prettierd, require("formatter.filetypes.css").stylelint },
			-- scss = { require("formatter.filetypes.scss").prettierd, require("formatter.filetypes.scss").stylelint },
			graphql = { require("formatter.filetypes.graphql").prettierd },
			html = { require("formatter.filetypes.html").prettierd },
			json = { require("formatter.filetypes.json").prettierd },
			markdown = { require("formatter.filetypes.markdown").prettierd },
			yaml = { require("formatter.filetypes.yaml").prettierd },
			sh = { require("formatter.filetypes.sh").shfmt },
			sql = { require("formatter.filetypes.sql").sqlformat },
			java = { require("formatter.filetypes.java").google_java_format },
			javascript = {
				require("formatter.filetypes.javascript").prettierd,
				require("formatter.filetypes.javascript").eslint_d,
			},
			javascriptreact = {
				require("formatter.filetypes.javascript").prettierd,
				require("formatter.filetypes.javascript").eslint_d,
			},
			typescript = {
				require("formatter.filetypes.typescript").prettierd,
				require("formatter.filetypes.javascript").eslint_d,
			},
			typescriptreact = {
				require("formatter.filetypes.typescript").prettierd,
				require("formatter.filetypes.javascript").eslint_d,
			},
			python = { require("formatter.filetypes.python").black, require("formatter.filetypes.python").isort },
		},
	})
end

return M

local M = {}

local sp = "cspell"
local esl = { "eslint_d", sp }

M.setup = function()
	local lint = require("lint")

	lint.linters_by_ft = {
		javascript = esl,
		javascriptreact = esl,
		typescript = esl,
		typescriptreact = esl,
		zsh = { "shellcheck" },
		sh = { "shellcheck" },
		yaml = { "yamllint", sp },
		css = { "stylelint", sp },
		scss = { "stylelint", sp },
		markdown = { "markdownlint", sp },
		lua = { "luacheck", sp },
		json = { "jsonlint", sp },
		python = { "flake8", sp },
	}

	vim.api.nvim_create_autocmd({ "BufWritePost" }, {
		callback = function()
			lint.try_lint()
		end,
	})
end

return M

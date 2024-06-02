local M = {}

M.setup = function()
	local h = require("hover")

	h.setup({
		init = function()
			-- Builtin providers
			require("hover.providers.lsp")
			require("hover.providers.gh")
			require("hover.providers.gh_user")
			require("hover.providers.jira")
			-- require("hover.providers.man")
			-- require("hover.providers.dictionary")

			-- Custom providers
			-- clickupProvider()
			-- trelloProvider()
		end,
		preview_opts = {
			border = "single",
			width = 50,
		},
		-- Whether the contents of a currently open hover window should be moved
		-- to a :h preview-window when pressing the hover keymap.
		preview_window = false,
		title = true,
	})
end
M.setup()

return M

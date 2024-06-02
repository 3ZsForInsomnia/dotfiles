local wk = require("which-key")
local trouble = require("trouble.providers.telescope")

wk.register({
	["<leader>"] = {
		f = {
			name = "Telescope Find",
			l = {
				name = "Telescope LSP",
				[""] = {
					function()
						require("trouble.providers.telescope").open_with_trouble()
					end,
					"Show diagnostics",
				},
				d = {
					function()
						require("trouble.providers.telescope").open_with_trouble()
					end,
					"Show diagnostics",
				},
			},
		},
	},
})

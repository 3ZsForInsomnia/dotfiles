local M = {}

function M.setup()
	require("regexplainer").setup({
		-- 'narrative'
		mode = "graphical", -- TODO: 'ascii', 'graphical'

		-- automatically show the explainer when the cursor enters a regexp
		auto = false,

		-- filetypes (i.e. extensions) in which to run the autocommand
		filetypes = {
			"java",
			"lua",
			"sh",
			"zsh",
			"html",
			"js",
			"cjs",
			"mjs",
			"ts",
			"jsx",
			"tsx",
			"cjsx",
			"mjsx",
		},

		-- Whether to log debug messages
		debug = false,

		-- 'split', 'popup'
		display = "popup",

		mappings = {
			toggle = "gR",
			-- examples, not defaults:
			-- show = 'gS',
			-- hide = 'gH',
			-- show_split = 'gP',
			-- show_popup = 'gU',
		},

		narrative = {
			separator = "\n",
		},
	})
end

return M

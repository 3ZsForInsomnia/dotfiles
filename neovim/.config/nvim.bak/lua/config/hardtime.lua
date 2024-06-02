local M = {}

function M.setup()
	require("hardtime").setup({
		disabled_filetypes = { "netrw", "lazy", "mason" },
		restricted_keys = {
			["w"] = { "n", "x" },
			["b"] = { "n", "x" },
			-- ["dd"] = { "n", "x" },
			-- ["dw"] = { "n", "x" },
		},
		hints = {
			["0w"] = {
				message = function()
					return "Use ^ instead of 0w"
				end,
				length = 2,
			},
			["wh"] = {
				message = function()
					return "Use e instead of wh"
				end,
				length = 2,
			},
		},
	})
end

return M

local M = {}

M.setup = function()
	require("jabs").setup({
		position = { "left", "bottom" },
		relative = "editor",
		clip_popup_size = true,

		width = 90,
		height = 40,
		border = "single",

		offset = {
			top = 0,
			bottom = 0,
			left = 1,
			right = 1,
		},

		sort_mru = true,
		split_filename = true,
		split_filename_path_width = 50,

		preview_position = "right",
		preview = {
			width = 100,
			height = 40,
			border = "single",
		},

		highlight = {
			current = "WildMenu",
			hidden = "IncSearch",
			split = "WarningMsg",
			alternate = "DiffAdd",
		},

		symbols = {
			current = "",
			split = "",
			alternate = "",
			hidden = "﬘",
			locked = "",
			ro = "",
			edited = "",
			terminal = "",
			default_file = "",
			terminal_symbol = "",
		},

		keymap = {
			close = "D",
			jump = "<cr>",
			h_split = "h",
			v_split = "v",
			preview = "p",
		},

		use_devicons = true,
	})
end

return M

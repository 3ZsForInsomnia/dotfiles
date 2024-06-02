local M = {}

M.setup = function()
	require("neoscroll").setup({
		mappings = {
			"<C-u>",
			"<C-d>",
			"<C-b>",
			"<C-f>",
			"<C-y>",
			"<C-e>",
			"zt",
			"zz",
			"zb",
		},
		hide_cursor = false,
		stop_eof = true,
		respect_scrolloff = false,
		cursor_scrolls_alone = true,
		easing_function = "cubic",
    pre_hook = nil,
    post_hook = nil,
	})

	local t = {}
	t["<C-u>"] = { "scroll", { "-vim.wo.scroll", "true", "100" } }
	t["<C-d>"] = { "scroll", { "vim.wo.scroll", "true", "100" } }
	t["<C-b>"] = { "scroll", { "-vim.api.nvim_win_get_height(0)", "true", "150" } }
	t["<C-f>"] = { "scroll", { "vim.api.nvim_win_get_height(0)", "true", "150" } }
	t["<C-y>"] = { "scroll", { "-0.10", "false", "50" } }
	t["<C-e>"] = { "scroll", { "0.10", "false", "50" } }
	t["zt"] = { "zt", { "100" } }
	t["zz"] = { "zz", { "100" } }
	t["zb"] = { "zb", { "100" } }

	require("neoscroll.config").set_mappings(t)
end

return M

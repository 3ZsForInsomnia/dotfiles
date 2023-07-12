local M = {}

M.setup = function()
	local ts_ctx = require("treesitter-context")
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
      "G",
      "gg",
		},
		hide_cursor = false,
		stop_eof = true,
		respect_scrolloff = false,
		cursor_scrolls_alone = true,
		easing_function = "cubic",
    -- pre_hook = nil,
    -- post_hook = nil,
		pre_hook = function(_)
			ts_ctx.disable()
		end,
		post_hook = function(_)
			ts_ctx.enable()
		end,
		performance_mode = false,
	})

	local t = {}
	t["<C-u>"] = { "scroll", { "-vim.wo.scroll", "true", "150" } }
	t["<C-d>"] = { "scroll", { "vim.wo.scroll", "true", "150" } }
	t["<C-b>"] = { "scroll", { "-vim.api.nvim_win_get_height(0)", "true", "200" } }
	t["<C-f>"] = { "scroll", { "vim.api.nvim_win_get_height(0)", "true", "200" } }
	t["<C-y>"] = { "scroll", { "-0.10", "false", "100" } }
	t["<C-e>"] = { "scroll", { "0.10", "false", "100" } }
	t["zt"] = { "zt", { "100" } }
	t["zz"] = { "zz", { "100" } }
	t["zb"] = { "zb", { "100" } }
  t["G"] = { "G", { "200" } }
  t["gg"] = { "gg", { "200" } }

	require("neoscroll.config").set_mappings(t)
end

return M

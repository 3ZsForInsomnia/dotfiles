local wk = require("which-key")
local v = vim
local a = v.api

local deleteNoNameBuffers = function()
	local buffers = v.tbl_filter(function(buf)
		return a.nvim_buf_is_valid(buf) and a.nvim_buf_get_option(buf, "buflisted")
	end, a.nvim_list_bufs())

	for _, buffer in ipairs(buffers) do
		if a.nvim_buf_get_name(buffer) == "" then
			a.nvim_buf_delete(buffer, {})
		end
	end
end

local f = function(number)
	return "<cmd>LualineBuffersJump! " .. number .. "<cr>"
end

wk.register({
	["<leader>b"] = {
		name = "Buffers",
		n = { "<cmd>new<cr><C-w>o", "Create new" },
		t = { "<cmd>new<cr><C-w>o<cmd>terminal<cr>", "Create new" },
		k = { "<cmd>bd<cr>", "Kill" },
		u = { deleteNoNameBuffers, "Kill all unnamed buffers" },
		l = { "<cmd>JABSOpen<cr>", "View open" },
		g = { ":b ", "Go to" },
		c = { "<C-g>", "Show path" },
		a = { "<cmd>b#<cr>", "Go to last edited" },
		r = { ":bd ", "Kill by name/pattern" },
		o = {
			function()
				v.api.nvim_command(":e " .. v.fn.expand("%:p:h"))
			end,
			"Open file in dir of current buffer",
		},
		q = { "<cmd>bd!<cr>", "Kill terminal/Exit immediately" },
		["1"] = { f(1), "Jump to Buffer 1" },
		["2"] = { f(2), "Jump to Buffer 2" },
		["3"] = { f(3), "Jump to Buffer 3" },
		["4"] = { f(4), "Jump to Buffer 4" },
		["5"] = { f(5), "Jump to Buffer 5" },
		["6"] = { f(6), "Jump to Buffer 6" },
		["7"] = { f(7), "Jump to Buffer 7" },
		["8"] = { f(8), "Jump to Buffer 8" },
		["9"] = { f(9), "Jump to Buffer 9" },
		["0"] = { f(0), "Jump to Buffer 10" },
		h = {
			[""] = { "<cmd>split<cr>", "Create new horizontal split" },
			n = { "<cmd>split<cr>", "New buffer with horizontal split" },
			["+"] = { "<C-w>10>", "Increase horizontal split size by 8" },
			["-"] = { "<C-w>10<", "Decrease horizontal split size by 8" },
		},
		v = {
			[""] = { "<cmd>vsplit<cr>", "Create new vertical split" },
			n = { "<cmd>vsplit<cr>", "Create new vertical split" },
			["+"] = { "<C-w>10+", "Increase vertical split size by 8" },
			["-"] = { "<C-w>10-", "Decrease vertical split size by 8" },
		},
		["="] = { "<C-w>=", "Equalize split sizes" },
	},
	["[b"] = { "<cmd>bp<cr>", "Go to previous buffer" },
	["]b"] = { "<cmd>bn<cr>", "Go to next buffer" },
	["<C-w>o"] = "Fullscreen current buffer if in buffer split",
	["<C-w>c"] = "Close split",
})

wk.register({
	zh = { "Hzz", "Go to top of page and center it" },
	zl = { "Lzz", "Go to bottom of page and center it" },
})

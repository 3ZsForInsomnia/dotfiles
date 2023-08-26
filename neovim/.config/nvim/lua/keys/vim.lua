local wk = require("which-key")

_G.logThis = function(str)
	local ft = vim.bo.filetype
	str = string.gsub(str, "%s+", "")

	if ft == "javascript" or ft == "typescript" then
		return 'console.log("' .. str .. '", ' .. str .. ");"
	elseif ft == "lua" then
		return 'print("' .. str .. '", vim.inspect(' .. str .. "))"
	end

	return "echo $" .. str
end

wk.register({
	["<leader>"] = {
		s = {
			name = "Sessions",
			s = {
				name = "Save sessions",
				n = { "<cmd>lua SaveSessionByName()<cr>", "With name" },
				a = { "<cmd>lua SaveSession('aliases')<cr>", "Aliases" },
				t = { "<cmd>lua SaveSession('temp')<cr>", "Temp" },
			},
			r = {
				name = "Restore sessions",
				n = { "<cmd>lua RestoreSessionByName()<cr>", "By name" },
				a = { "<cmd>lua RestoreSession('aliases')<cr>", "Aliases" },
				t = { "<cmd>lua RestoreSession('temp')<cr>", "Temp" },
			},
			d = { "<cmd>lua DeleteSessionByName()<cr>", "Delete named session" },
		},
		z = {
			name = "Personal",
			y = {
				"<cmd>let @+ = expand('%:.')<cr>",
				"Copy filename + relative path to clipboard",
			},
			ws = {
				"<cmd>w<cr><bar><cmd>source %<cr>",
				"Write and source current file",
			},
			wsi = {
				"<cmd>w<cr><bar><cmd>source ~/.config/nvim/init.lua<cr>",
				"Write and source nvim config",
			},
			z = { "<cmd>w<cr>", "Write file" },
			ta = { "<cmd>set number!<cr>", "Toggle absolute line numbers" },
			tr = {
				"<cmd>set relativenumber!<cr>",
				"Toggle relative line numbers",
			},
			l = {
				'vaw"qyo<c-r>=luaeval(\'logThis(vim.fn.getreg("q"))\')<cr><esc><up>',
				"Insta-log anything while in normal mode",
			},
		},
		ts = { ":ts ", "Go to tag by name" },
		["dm!"] = { "<cmd>delmarks!<cr>", "Delete all marks" },
		[","] = { "<cmd>nohlsearch<cr>", "Stop highlighting search results" },
	},
	["<C-"] = {
		["[>"] = { "<cmd>pop<cr>", "Pop entry off tag stack" },
	},
	["<M-d>"] = { '"_d', "Delete but preserve yanked register" },
	["<esc>"] = { "<esc><cmd>nohlsearch<cr>", "Escape and stop highlighting search" },
	["*"] = { "*zz", "Search word under cursor and center" },
})

wk.register({
	m = {
		name = "Marks",
		["0"] = "Good",
		["9"] = "Investigation path",
		["8"] = "Confusion/question",
		["7"] = "Bad",
		["6"] = "Home/current workspace",
		["5"] = "Information",
	},
	["["] = {
		name = "Named Bookmarks",
		["0"] = { "<Plug>(Marks-prev-bookmark0)", "Good" },
		["9"] = { "<Plug>(Marks-prev-bookmark9)", "Investigation path" },
		["8"] = { "<Plug>(Marks-prev-bookmark8)", "Confusion/question" },
		["7"] = { "<Plug>(Marks-prev-bookmark7)", "Bad" },
		["6"] = { "<Plug>(Marks-prev-bookmark6)", "Home/current workspace" },
		["5"] = { "<Plug>(Marks-prev-bookmark5)", "Information" },
	},
	["]"] = {
		name = "Named Bookmarks",
		["0"] = { "<Plug>(Marks-next-bookmark0)", "Good" },
		["9"] = { "<Plug>(Marks-next-bookmark9)", "Investigation path" },
		["8"] = { "<Plug>(Marks-next-bookmark8)", "Confusion/question" },
		["7"] = { "<Plug>(Marks-next-bookmark7)", "Bad" },
		["6"] = { "<Plug>(Marks-next-bookmark6)", "Home/current workspace" },
		["5"] = { "<Plug>(Marks-next-bookmark5)", "Information" },
	},
})

wk.register({
	["<C-"] = {
		["c>"] = { '"+y', "Copy to clipboard" },
		["d>"] = { '"_d', "Delete but preserve yanked register" },
		["s>"] = {
			"<cmd>lua require('luasnip.extras.select_choice')()<cr>",
			"Open select popup for luasnip choice",
		},
	},
}, { mode = "v" })

wk.register({ ["<esc>"] = { "<C-\\><C-n>", "Escape but for terminal mode" } }, { mode = "t" })

wk.register({
	["<C-"] = {
		["j>"] = {
			"<Plug>luasnip-next-choice",
			"Cycle to next luasnip choicenode option",
		},
		["k>"] = {
			"<Plug>luasnip-prev-choice",
			"Cycle to prev luasnip choicenode option",
		},
		["e>"] = {
			"<Plug>luasnip-expand-snippet",
			"Luasnip expand snippet under cursor",
		},
		["s>"] = {
			"<cmd>lua require('luasnip.extras.select_choice')()<cr>",
			"Open select popup for luasnip choice",
		},
	},
}, { mode = "s" })

wk.register({
	['"""'] = { '"<C-o>A"', 'Wrap everything from cursor to end of line in ""' },
	['""w'] = { '"<C-o>w<bs>" ', 'Wrap everything from cursor to end of word in ""' },
	['""b'] = { '"<C-o>2b"', 'Wrap everything from cursor to end of word in ""' },
	["<C-;>"] = { '<C-o>diw"<c-o>p" <c-o>2b<bs>', 'Wrap current word in ""' },

	["'''"] = { "'<C-o>A'", "Wrap everything from cursor to end of line in ''" },
	["''w"] = { "'<C-o>w<bs>' ", "Wrap everything from cursor to end of word in ''" },
	["''b"] = { "'<C-o>2b'", "Wrap everything from cursor to end of word in ''" },
	["<C-'>"] = { "<C-o>diw'<c-o>p' <c-o>2b<bs>", "Wrap current word in ''" },

	["((("] = { "(<C-o>A)", "Wrap everything from cursor to end of line in ()" },
	["((w"] = { "(<C-o>w<bs>) ", "Wrap next word in ()" },
	["((b"] = { ")<C-o>2b(", "Wrap previous word in ()" },
	["<C-9>"] = { "<C-o>diw(<c-o>p) <c-o>2b<bs>", "Wrap current word in ()" },

	["{{{"] = { "{<C-o>A}", "Wrap everything from cursor to end of line in {}" },
	["{{w"] = { "{<C-o>w<bs>} ", "Wrap next word in {}" },
	["{{b"] = { "}<C-o>2b{", "Wrap previous word in {}" },
	["<C-8>"] = { "<C-o>diw{<c-o>p} <c-o>2b<bs>", "Wrap current word in {}" },

	["[[["] = { "[<C-o>A]", "Wrap everything from cursor to end of line in []" },
	["[[w"] = { "[<C-o>w<bs>] ", "Wrap next word in []" },
	["[[b"] = { "]<C-o>2b[", "Wrap previous word in []" },
	["<C-7>"] = { "<C-o>diw[<c-o>p] <c-o>2b<bs>", "Wrap current word in []" },

	["<C-4>"] = { "<C-o>diw${<c-o>p} <c-o>2b<bs>", "Wrap current word in ${}" },

	["<C-"] = {
		["c>"] = { "<esc>`^", "Escape and keep location" },
		["l>"] = {
			'<esc>vaw"qyo<c-r>=luaeval(\'logThis(vim.fn.getreg("q"))\')<cr><up>',
			"Insta-log anything while in insert mode",
		},
		["j>"] = {
			"<Plug>luasnip-next-choice",
			"Cycle to next luasnip choicenode option",
		},
		["k>"] = {
			"<Plug>luasnip-prev-choice",
			"Cycle to prev luasnip choicenode option",
		},
		["e>"] = {
			"<Plug>luasnip-expand-snippet",
			"Luasnip expand snippet under cursor",
		},
		["s>"] = {
			"<cmd>lua require('luasnip.extras.select_choice')()<cr>",
			"Open select popup for luasnip choice",
		},
		["-w>"] = { "<c-g>u<c-w>", "Safely delete previous word" },
		["-u>"] = { "<c-g>u<c-u>", "Safely delete everything before cursor" },
		["-x>"] = { "<c-o>dw", "Delete next word" },
		["-d>"] = { "<c-o>D", "Delete to end of line" },
	},
}, { mode = "i" })

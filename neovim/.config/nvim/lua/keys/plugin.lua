local wk = require("which-key")

local f = function(command)
	return "<cmd>lua require('refactoring').refactor('" .. command .. "')<cr>"
end

local v = vim.fn
local getRangeByMarksOrLines = function(a, b)
	local locA = v.getpos("'" .. a)
	local locB = v.getpos("'" .. b)

	local s_start = { row = locA[2], col = locA[3] }
	-- Add +1 to ending line number to since it is exclusive of end
	local s_end = { row = locB[2] + 1, col = locB[3] }

	return { s_start = s_start, s_end = s_end }
end

local splitRange = function(range)
	local parts = string.gmatch(range, ",")
	local a = parts[1]
	local b = parts[2]

	return getRangeByMarksOrLines(a, b)
end

local takeSnapshotBetweenMarks = function()
	local config = { prompt = 'Select two marks, comma separated (e.g. "a,b"' }
	local callback = function(input)
		local range = splitRange(input)
		require("code-shot").shot(range)
	end

	vim.ui.input(config, callback)
end

wk.register({
	p = {
		name = "Misc Plugins",
		s = {
			name = "Screenshots",
			s = { "<cmd>lua require('code-shot').shot()", "Take codeshot of file" },
			m = {
				function()
					takeSnapshotBetweenMarks()
				end,
				"Take codeshot between marks",
			},
		},
		v = { "<cmd>Vista!!<cr>", "Toggle Vista" },
		t = { "<cmd>VimTrello<cr>", "Open Trello" },
		g = {
			"<cmd>Neogen<cr>",
			"Generate docstring for whatever is under cursor",
		},
		f = { "<cmd>Twilight<cr>", "Dim unused code (twilight)" },
		u = { "<cmd>UndotreeToggle<cr>", "UndoTree" },
		r = {
			name = "Refactoring",
			b = { f("Extract Block"), "Extract Block" },
			f = { f("Extract Block To File"), "Extract Block To File" },
			i = { f("Inline Variable"), "Inline Variable" },
		},
		c = {
			[""] = { "<cmd>Colortils picker #<cword><cr>", "Picker" },
			name = "Color Utils",
			p = { "<cmd>Colortils picker #<cword><cr>", "Picker" },
			l = { "<cmd>Colortils lighten #<cword><cr>", "Lighten" },
			d = { "<cmd>Colortils darken #<cword><cr>", "Darken" },
			c = { "<cmd>Colortils css #<cword><cr>", "CSS colors" },
			g = { "<cmd>Colortils gradient #<cword><cr>", "Gradient" },
		},
		q = {
			name = "Bookmarks Quickfix list",
			a = { "<cmd>BookmarksQFListAll<cr>", "View all bookmarks in qflist" },
			q = { "<cmd>MarksQFListGlobal<cr>", "View all marks in qflist" },
			["5"] = {
				"<cmd>BookmarksQFList 5<cr>",
				"View group 5 bookmarks in qflist (info)",
			},
			["6"] = {
				"<cmd>BookmarksQFList 6<cr>",
				"View group 6 bookmarks in qflist (home)",
			},
			["7"] = {
				"<cmd>BookmarksQFList 7<cr>",
				"View group 7 bookmarks in qflist (wrong/bad)",
			},
			["8"] = {
				"<cmd>BookmarksQFList 8<cr>",
				"View group 8 bookmarks in qflist (investigating)",
			},
			["9"] = {
				"<cmd>BookmarksQFList 9<cr>",
				"View group 9 bookmarks in qflist (confusing)",
			},
			["0"] = {
				"<cmd>BookmarksQFList 0<cr>",
				"View group 0 bookmarks in qflist (good)",
			},
		},
		l = {
			name = "Bookmarks Location list",
			a = { "<cmd>BookmarksListAll<cr>", "View all bookmarks in loclist" },
			l = { "<cmd>MarksListBuf<cr>", "View Marks in Buffer in loclist" },
			["5"] = {
				"<cmd>BookmarksList 5<cr>",
				"View group 5 bookmarks in loclist (info)",
			},
			["6"] = {
				"<cmd>BookmarksList 6<cr>",
				"View group 6 bookmarks in loclist (home)",
			},
			["7"] = {
				"<cmd>BookmarksList 7<cr>",
				"View group 7 bookmarks in loclist (wrong/bad)",
			},
			["8"] = {
				"<cmd>BookmarksList 8<cr>",
				"View group 8 bookmarks in loclist (investigating)",
			},
			["9"] = {
				"<cmd>BookmarksList 9<cr>",
				"View group 9 bookmarks in loclist (confusing)",
			},
			["0"] = {
				"<cmd>BookmarksList 0<cr>",
				"View group 0 bookmarks in loclist (good)",
			},
		},
	},
	f = { o = { "<cmd>ObsidianSearch<cr>", "Search vault" } },
}, { prefix = "<leader>" })

-- This is here since it is mostly intended to be used with tables in Obsidian notes
wk.register({
	["<C-t"] = { ":Tabularize /", "Tabularize text based on pattern" },
	["CS"] = {
		function()
			require("code-shot").shot()
		end,
		"Take codeshot",
	},
}, { mode = "v" })

wk.register({
	r = {
		name = "Refactoring",
		e = { f("Extract Function"), "Extract Function" },
		f = { f("Extract Function To File"), "Extract Function To File" },
		v = { f("Extract Variable"), "Extract Variable" },
		i = { f("Inline Variable"), "Inline Variable" },
	},
}, { prefix = "<leader>z", mode = "v" })

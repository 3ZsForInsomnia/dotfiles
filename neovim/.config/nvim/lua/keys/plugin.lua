local wk = require("which-key")

local f = function(command)
	return "<cmd>lua require('refactoring').refactor('" .. command .. "')<cr>"
end

wk.register({
	p = {
		name = "Misc Plugins",
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
		o = {
			name = "Obsidian",
			t = { "<cmd>ObsidianToday<cr>", "Open today's note" },
			n = { ":ObsidianNew ", "Create new note" },
			q = { "<cmd>ObsidianQuickSwitch<cr>", "Open quick switcher" },
			i = { "<cmd>ObsidianTemplate<cr>", "Insert template selected" },
			l = { "<cmd>ObsidianLink<cr>", "Create link" },
			f = { "<cmd>ObsidianFollowLink<cr>", "Follow link" },
			o = {
				"<cmd>ObsidianOpen<cr>",
				"Open note in current buffer in Obsidian app",
			},
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
wk.register({ ["<C-t"] = { ":Tabularize /", "Tabularize text based on pattern" } }, { mode = "v" })

wk.register({
	r = {
		name = "Refactoring",
		e = { f("Extract Function"), "Extract Function" },
		f = { f("Extract Function To File"), "Extract Function To File" },
		v = { f("Extract Variable"), "Extract Variable" },
		i = { f("Inline Variable"), "Inline Variable" },
	},
}, { prefix = "<leader>z", mode = "v" })

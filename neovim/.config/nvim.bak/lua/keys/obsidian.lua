local wk = require("which-key")

wk.register({
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
}, { prefix = "<leader>" })

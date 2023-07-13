local wk = require("which-key")

local f = function(arg)
	return "<cmd>Neogit " .. arg .. "<cr>"
end

wk.register({
	g = {
		name = "Git",
		n = {
			name = "Neogit view",
			s = { f(""), "Status" },
			c = { f("commit"), "Commit" },
			r = { f("rebase"), "Rebase" },
			m = { f("merge"), "Merge" },
			l = { f("log"), "Log" },
			t = { f("stash"), "Stash" },
			b = { f("branch"), "Branch" },
			p = { f("cherry_pick"), "Cherry pick" },
		},
	},
}, { prefix = "<leader>" })

local wk = require("which-key")
local v = vim
local w = v.wo
local s = v.schedule
local stageHunk = { "<cmd>Gitsigns stage_hunk<cr>", "Stage current hunk" }
local resetHunk = { "<cmd>Gitsigns reset_hunk<cr>", "Reset current hunk" }

local mainBranch = function()
	return string.gsub(v.fn.system("git remote show origin | sed -n '/HEAD branch/s/.*: //p'"), "\n", "")
end

local f = function(command)
	return "<cmd>Diffview" .. command .. "<cr>"
end

local n = function(command)
	return "<cmd>Neogit " .. command .. "<cr>"
end

local p = function(object, command, args)
	if args then
		return "<cmd>Octo " .. object .. " " .. command .. " " .. args .. "<cr>"
	else
		return "<cmd>Octo " .. object .. " " .. command .. " " .. "<cr>"
	end
end
local pr = function(command, args)
	return p("pr", command, args)
end
local re = function(command, args)
	return p("repo", command, args)
end
local th = function(command, args)
	return p("thread", command, args)
end
local rv = function(command, args)
	return p("review", command, args)
end
local c = function(command, args)
	return p("comment", command, args)
end

local M = {}

M.setup = function(bufnr)
	local function map(mode, l, r, opts)
		opts = opts or {}
		opts.buffer = bufnr
		v.keymap.set(mode, l, r, opts)
	end

	-- Navigation
	map({ "n", "v" }, "]h", function()
		if w.diff then
			return "]c"
		end
		s(function()
			require("gitsigns").next_hunk()
		end)
		return "<Ignore>"
	end, { expr = true })

	map({ "n", "v" }, "[h", function()
		if w.diff then
			return "[c"
		end
		s(function()
			require("gitsigns").prev_hunk()
		end)
		return "<Ignore>"
	end, { expr = true })

	-- Text object
	map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")

	wk.register({
		["<leader>g"] = {
			name = "Git",
			s = {
				name = "Stage",
				s = stageHunk,
				r = resetHunk,
				S = {
					function()
						require("gitsigns").stage_buffer()
					end,
					"Stage whole buffer",
				},
				R = {
					function()
						require("gitsigns").reset_buffer()
					end,
					"Reset whole buffer",
				},
				u = {
					function()
						require("gitsigns").undo_stage_hunk()
					end,
					"Undo staged hunk",
				},
				p = {
					function()
						require("gitsigns").preview_hunk()
					end,
					"Preview hunk",
				},
			},
			b = {
				function()
					require("gitsigns").blame_line({ full = true })
				end,
				"Show full blame in floating window",
			},
			t = {
				name = "Toggle",
				t = {
					function()
						require("gitsigns").toggle_current_line_blame()
					end,
					"Toggle blame line virtual text for cursorline",
				},
				w = {
					function()
						require("gitsigns").toggle_word_diff()
					end,
					"Toggle word diff",
				},
				d = {
					function()
						require("gitsigns").toggle_deleted()
					end,
					"Show deleted (does not re-add it!)",
				},
				f = { f("ToggleFiles"), "Toggle Files" },
			},
			d = {
				name = "Diff against",
				i = {
					function()
						require("gitsigns").diffthis()
					end,
					"Current index, this buffer",
				},
				n = {
					function()
						require("gitsigns").diffthis("~")
					end,
					"Last n commits, this buffer",
				},
				v = { f("Open"), "Open" },
				c = { f("Close"), "Close" },
				m = {
					f("Open origin/" .. mainBranch()),
					"origin/${mainBranchName}",
				},
				o = { ":DiffviewOpen origin/", "Open origin/${branch}" },
				h = { ":DiffviewOpen HEAD~n", "Open HEAD~${numberOfCommits}" },
				p = { f("Open origin/HEAD...HEAD"), "PR to its base" },
			},
			q = {
				"<cmd>Gitsigns setqflist all",
				"Send all hunks in all files to qf list",
			},
			l = {
				function()
					require("gitsigns").setloclist(0, 0)
				end,
				"Send all hunks in current buffer to loc list",
			},
			n = {
				name = "Neogit view",
				s = { n(""), "Status" },
				c = { n("commit"), "Commit" },
				r = { n("rebase"), "Rebase" },
				m = { n("merge"), "Merge" },
				l = { n("log"), "Log" },
				t = { n("stash"), "Stash" },
				b = { n("branch"), "Branch" },
				p = { n("cherry_pick"), "Cherry pick" },
			},
			p = {
				name = "PR's with Octo",
				a = {
					name = "Assign",
					r = { ":Octo reviewer add x", "Assign reviewer" },
					a = { ":Octo assignee add x", "Assign user" },
					u = { ":Octo assignee remove x", "Unassign user" },
				},
				p = {
					name = "PR's",
					l = {
						name = "List...",
						["<cr>"] = { pr("list"), "PRs" },
						f = { ":Octo pr list ", "PRs with a filter" },
						d = { pr("changes"), "PR hunks" },
						i = { pr("diff"), "Full PR diff" },
						c = { pr("commits"), "Commits" },
					},
					c = { pr("create"), "Create PR from current branch" },
					o = { pr("checkout"), "Checkout PR" },
					q = { pr("close"), "Close the current PR" },
					r = { pr("ready"), "Show full PR diff" },
					g = { pr("checks"), "Show PR checks status" },
					b = { pr("browser"), "Show full PR diff" },
					u = { pr("url"), "Show full PR diff" },
				},
				c = {
					name = "Comments",
					a = { c("add"), "Add a comment" },
					d = { c("delete"), "Delete comment" },
				},
				t = {
					name = "Threads",
					r = { th("resolve"), "Resolve thread" },
					u = { th("unresolve"), "Unresolve thread" },
				},
				v = {
					name = "Review",
					n = { rv("start"), "Start a new review" },
					s = { rv("submit"), "Submit review" },
					e = { rv("resume"), "Edit a review" },
					d = { rv("discard"), "Discard review" },
					c = { rv("comments"), "View pending comments" },
					m = { rv("commit"), "Review a specific commit" },
					q = { rv("close"), "Close the review window/return to the PR" },
				},
				r = {
					name = "Repo",
					l = { re("list"), "List repos I work on" },
					o = { re("browser"), "Open repo in browser" },
				},
			},
		},
		gx = "Diffview delete conflict",
		["]x"] = "Jump to next conflict marker",
		["[x"] = "Jump to previous conflict marker",
		["[h"] = "Jump to previous hunk",
		["]h"] = "Jump to next hunk",
	})

	wk.register({ ["<leader>g"] = { s = stageHunk, r = resetHunk } }, { mode = "v" })
end

return M

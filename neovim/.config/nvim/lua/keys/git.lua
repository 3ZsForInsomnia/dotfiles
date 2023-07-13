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

local M = {}

M.setup = function(bufnr)
	local gs = package.loaded.gitsigns
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
			gs.next_hunk()
		end)
		return "<Ignore>"
	end, { expr = true })

	map({ "n", "v" }, "[h", function()
		if w.diff then
			return "[c"
		end
		s(function()
			gs.prev_hunk()
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
				S = { gs.stage_buffer, "Stage whole buffer" },
				R = { gs.reset_buffer, "Reset whole buffer" },
				u = { gs.undo_stage_hunk, "Undo staged hunk" },
				p = { gs.preview_hunk, "Preview hunk" },
			},
			b = {
				function()
					gs.blame_line({ full = true })
				end,
				"Show full blame in floating window",
			},
			t = {
				name = "Toggle",
				t = {
					gs.toggle_current_line_blame,
					"Toggle blame line virtual text for cursorline",
				},
				w = { gs.toggle_word_diff, "Toggle word diff" },
				d = { gs.toggle_deleted, "Show deleted (does not re-add it!)" },
				f = { f("ToggleFiles"), "Toggle Files" },
			},
			d = {
				name = "Diff against",
				i = { gs.diffthis, "Current index, this buffer" },
				n = {
					function()
						gs.diffthis("~")
					end,
					"Last n commits, this buffer",
				},
				v = { f("Open"), "Open" },
				c = { f("Close"), "Close" },
				m = {
					function()
						print(f("Open origin/" .. mainBranch()))
					end,
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
					gs.setloclist(0, 0)
				end,
				"Send all hunks in current buffer to loc list",
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

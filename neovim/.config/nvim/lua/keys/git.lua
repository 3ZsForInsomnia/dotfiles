local wk = require("which-key")
local stageHunk = { "<cmd>Gitsigns stage_hunk<cr>", "Stage current hunk" }
local resetHunk = { "<cmd>Gitsigns reset_hunk<cr>", "Reset current hunk" }

local mainBranch = function()
	return string.gsub(vim.fn.system("git remote show origin | sed -n '/HEAD branch/s/.*: //p'"), "\n", "")
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
		vim.keymap.set(mode, l, r, opts)
	end

	-- Navigation
	map({ "n", "v" }, "]h", function()
		if vim.wo.diff then
			return "]c"
		end
		vim.schedule(function()
			gs.next_hunk()
		end)
		return "<Ignore>"
	end, { expr = true })

	map({ "n", "v" }, "[h", function()
		if vim.wo.diff then
			return "[c"
		end
		vim.schedule(function()
			gs.prev_hunk()
		end)
		return "<Ignore>"
	end, { expr = true })

	-- Text object
	map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")

	wk.register({
		["<leader>g"] = {
			name = "Git",
      s = stageHunk,
      r = resetHunk,
      S = { gs.stage_buffer, "Stage whole buffer" },
      u = { gs.undo_stage_hunk, "Undo staged hunk" },
      R = { gs.reset_buffer, "Reset whole buffer" },
      p = { gs.preview_hunk, "Preview hunk" },
      b = {
        name = "Blame",
        [""] = {
          function()
            gs.blame_line({ full = true })
          end,
          "Show full blame in floating window",
        },
        t = {
          gs.toggle_current_line_blame,
          "Toggle blame line virtual text for cursorline",
        },
      },
      w = { gs.toggle_word_diff, "Toggle word diff" },
      d = {
        name = "Diff",
        [""] = { gs.diffthis, "Diff against current index" },
        d = { gs.toggle_deleted, "Show deleted (does not re-add it!)" },
        n = { ":Gitsigns diffthis ~n", "Diff the last [n] commits" },
        m = {
          function()
            gs.diffthis("~")
          end,
          "Diff against main branch",
        },
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
      [""] = { f("Open"), "Open" },
      m = {
        function()
          print(f("Open origin/" .. mainBranch()))
        end,
        "Open origin/${mainBranchName}",
      },
      o = { ":DiffviewOpen origin/", "Open origin/${branch}" },
      h = { ":DiffviewOpen HEAD~n", "Open HEAD~${numberOfCommits}" },
      c = { f("Close"), "Close" },
      f = { f("ToggleFiles"), "Toggle Files" },
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

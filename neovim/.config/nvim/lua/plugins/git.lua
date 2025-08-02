local v = vim

local git_status_to_messages = function()
  local output = v.fn.system("git status")

  v.notify(output, v.log.levels.INFO)
end

local git_add_all = function()
  local add_output = v.fn.system("git add .")
  local status_output = v.fn.system("git status")

  v.notify(add_output, v.log.levels.INFO)
  v.notify(status_output, v.log.levels.INFO)
end

local cmd = require("helpers").k_cmd
local k = require("helpers").k

local g = "<leader>g"

local n = function(command)
  return "Neogit " .. command
end

local gn = g .. "n"

local o = function(command)
  return "Octo " .. command
end

local prs = g .. "p" -- And repos
local comments = g .. "c" -- And threads and reactions
local reviews = g .. "r" -- And  reviewers, assignees, and actual reviews

local revman = "<leader>p"

local function jump_unreviewed(direction)
  local target_buf, win = nil, nil
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    local name = vim.api.nvim_buf_get_name(buf)
    if name:find("OctoChangedFiles") then
      target_buf = buf
      win = vim.fn.bufwinid(buf)
      break
    end
  end
  if not target_buf then
    vim.notify("No OctoChangedFiles buffer found", vim.log.levels.WARN)
    return
  end

  if win == -1 or win == nil then
    vim.cmd("sbuffer " .. target_buf)
    win = vim.fn.bufwinid(target_buf)
  else
    vim.api.nvim_set_current_win(win)
  end

  local lines = vim.api.nvim_buf_get_lines(target_buf, 0, -1, false)
  local cur_line = vim.api.nvim_win_get_cursor(win)[1] -- 1-based

  local indices = {}
  for i, line in ipairs(lines) do
    if line:find("󰄰") or line:find("󰀨") then
      table.insert(indices, i)
    end
  end
  if #indices == 0 then
    vim.notify("No unreviewed/changed files found", vim.log.levels.INFO)
    return
  end

  -- Find the next/prev index, skipping the current line if it's a match
  local target
  if direction == "next" then
    for _, i in ipairs(indices) do
      if i > cur_line then
        target = i
        break
      end
    end
    if not target then
      target = indices[1] -- wrap
    end
  else -- prev
    for idx = #indices, 1, -1 do
      if indices[idx] < cur_line then
        target = indices[idx]
        break
      end
    end
    if not target then
      target = indices[#indices] -- wrap
    end
  end

  -- Only simulate <CR> if the target line is a file entry
  if target then
    vim.api.nvim_win_set_cursor(win, { target, 0 })
    -- Confirm the line is a file entry (should match the icons)
    local line = lines[target]
    if line and (line:find("󰄰") or line:find("󰀨")) then
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, false, true), "n", false)
    end
  end
end

vim.keymap.set("n", "]u", function()
  jump_unreviewed("next")
end, { desc = "Next unreviewed/changed file" })
vim.keymap.set("n", "[u", function()
  jump_unreviewed("prev")
end, { desc = "Prev unreviewed/changed file" })

return {
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      sign_priority = 20,
    },
  },
  {
    "NeogitOrg/neogit",
    event = "VeryLazy",
    opts = {
      graph_style = "unicode",
      process_spinner = true,
      initial_branch_name = "", -- Placeholder value for input
      disable_line_numbers = false,
      disable_relative_line_numbers = false,
      commit_editor = {
        staged_diff_split_kind = "auto",
      },
      -- Each Integration is auto-detected through plugin presence, however, it can be disabled by setting to `false`
      integrations = {
        telescope = true,
        diffview = true,
      },
    },
    keys = {
      {
        gn .. "a",
        function()
          git_add_all()
        end,
        desc = "Add all",
      },
      {
        gn .. "s",
        function()
          git_status_to_messages()
        end,
        desc = "Status",
      },
      cmd({
        key = gn .. "c",
        action = n("commit"),
        desc = "Commit",
      }),
      cmd({
        key = gn .. "r",
        action = n("rebase"),
        desc = "Rebase",
      }),
      cmd({
        key = gn .. "m",
        action = n("merge"),
        desc = "Merge",
      }),
      cmd({
        key = gn .. "l",
        action = n("log"),
        desc = "Log",
      }),
      cmd({
        key = gn .. "b",
        action = n("branch"),
        desc = "Branch",
      }),
      cmd({
        key = gn .. "t",
        action = n("stash"),
        desc = "Stash",
      }),
      cmd({
        key = gn .. "p",
        action = n("pull"),
        desc = "Pull",
      }),
      cmd({
        key = gn .. "u",
        action = n("push"),
        desc = "Push",
      }),
      cmd({
        key = gn .. "f",
        action = n("fetch"),
        desc = "Fetch",
      }),
      cmd({
        key = gn .. "d",
        action = n("diff"),
        desc = "Diff",
      }),
      cmd({
        key = gn .. "C",
        action = n("cherry_pick"),
        desc = "Cherry pick",
      }),
    },
  },
  {
    "pwntester/octo.nvim",
    event = "VeryLazy",
    opts = {
      suppress_missing_scope = {
        projects_v2 = true,
      },
      default_merge_method = "squash",
      default_to_projects_v2 = true,
      notifications = {
        current_repo_only = true,
      },
      runs = {
        icons = {
          success = "✓",
        },
      },
      mappings = {
        notification = {
          read = { lhs = "<C-r>", desc = "mark notification as read" },
        },
      },
    },
    keys = {
      { "<leader>gi", false },
      { "<leader>gI", false },
      { "<leader>gp", false },
      { "<leader>gP", false },
      { "<leader>gr", false },
      { "<leader>gS", false },
      cmd({
        key = g .. "S",
        action = o("search"),
        desc = "Octo Search",
      }),
      cmd({
        key = g .. "o",
        action = o("notification list"),
        desc = "Notifications",
      }),
      cmd({
        key = g .. "R",
        action = o("review"),
        desc = "Review the currently viewed PR",
      }),

      ---
      --- PRs
      ---
      cmd({
        key = prs .. "b",
        action = o("pr browser"),
        desc = "Open PR in Browser",
      }),
      cmd({
        key = prs .. "B",
        action = o("repo browser"),
        desc = "Open Repo in Browser",
      }),
      cmd({
        key = prs .. "c",
        action = o("pr create"),
        desc = "Create PR",
      }),
      cmd({
        key = prs .. "C",
        action = o("pr checks"),
        desc = "See PR Checks",
      }),
      cmd({
        key = prs .. "d",
        action = o("pr changes"),
        desc = "PR Changes",
      }),
      cmd({
        key = prs .. "e",
        action = o("pr edit"),
        desc = "Edit PR",
      }),
      cmd({
        key = prs .. "h",
        action = o("pr diff"),
        desc = "PR Diff",
      }),
      cmd({
        key = prs .. "l",
        action = o("pr list"),
        desc = "List PRs",
      }),
      cmd({
        key = prs .. "o",
        action = o("pr checkout"),
        desc = "Checkout PR",
      }),
      cmd({
        key = prs .. "r",
        action = o("repo list"),
        desc = "List Repos",
      }),
      cmd({
        key = prs .. "s",
        action = o("pr search"),
        desc = "Search PRs",
      }),

      ---
      --- Reviews
      ---
      cmd({
        key = reviews .. "a",
        action = o("assignee add"),
        desc = "Add a PR Assignee",
      }),
      cmd({
        key = reviews .. "A",
        action = o("reviewer add"),
        desc = "Add a PR Reviewer",
      }),
      cmd({
        key = reviews .. "c",
        action = o("review comments"),
        desc = "See PR Comments",
      }),
      cmd({
        key = reviews .. "C",
        action = o("review close"),
        desc = "Close a PR Review",
      }),
      cmd({
        key = reviews .. "d",
        action = o("review discard"),
        desc = "Discard a PR Review",
      }),
      cmd({
        key = reviews .. "r",
        action = o("review resume"),
        desc = "Resume a PR Review",
      }),
      cmd({
        key = reviews .. "s",
        action = o("review start"),
        desc = "Start a PR Review",
      }),
      cmd({
        key = reviews .. "S",
        action = o("review submit"),
        desc = "Submit a PR Review",
      }),

      ---
      --- Comments, Threads, Reactions
      ---
      cmd({
        key = comments .. "c",
        action = o("comment add"),
        desc = "Add a PR Comment",
      }),
      cmd({
        key = comments .. "C",
        action = o("comment delete"),
        desc = "Delete a PR Comment",
      }),

      cmd({
        key = comments .. "t",
        action = o("thread resolve"),
        desc = "Resolve a PR Thread",
      }),
      cmd({
        key = comments .. "T",
        action = o("thread unresolve"),
        desc = "Unresolve a PR Thread",
      }),
    },
  },
  {
    dir = "~/src/revman.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "kkharji/sqlite.lua",
      "pwntester/octo.nvim",
    },
    lazy = false,
    config = true,
    opts = {
      database = {
        path = vim.fn.stdpath("state") .. "/revman/revman.db",
      },
      retention = {
        days = 0,
      },
      background = {
        frequency = 15,
      },
      keymaps = {
        save_notes = "<leader>zz",
      },
      log_level = "info",
    },
    keys = {
      cmd({
        key = revman .. "S",
        action = "RevmanSyncAllPRs",
        desc = "Sync all PRs",
      }),
      cmd({
        key = revman .. "s",
        action = "RevmanSyncPR",
        desc = "Sync current PR",
      }),
      cmd({
        key = revman .. "L",
        action = "RevmanListPRs",
        desc = "List all PRs",
      }),
      cmd({
        key = revman .. "l",
        action = "RevmanListOpenPRs",
        desc = "List open PRs",
      }),
      cmd({
        key = revman .. "r",
        action = "RevmanListPRsNeedingReview",
        desc = "List PRs needing review",
      }),
      cmd({
        key = revman .. "m",
        action = "RevmanListMergedPRs",
        desc = "List merged PRs",
      }),
      cmd({
        key = revman .. "n",
        action = "RevmanNudgePRs",
        desc = "Nudge PRs",
      }),
      cmd({
        key = revman .. "R",
        action = "RevmanListRepos",
        desc = "List Repos",
      }),
      k({
        key = revman .. "a",
        action = ":RevmanAddPR ",
        desc = "Add PR",
      }),
      cmd({
        key = revman .. "A",
        action = "RevmanAddRepo",
        desc = "Add Repo",
      }),
      cmd({
        key = revman .. "U",
        action = "RevmanListAuthors",
        desc = "List Authors",
      }),
      cmd({
        key = revman .. "I",
        action = "RevmanShowNotes",
        desc = "Show notes for current PR",
      }),
      cmd({
        key = revman .. "i",
        action = "RevmanAddNote",
        desc = "Add note to current PR",
      }),
      cmd({
        key = revman .. "s",
        action = "RevmanSetStatus",
        desc = "Set status for current PR",
      }),
      cmd({
        key = revman .. "S",
        action = "RevmanSetStatusForCurrentPR",
        desc = "Set status for current PR",
      }),
      cmd({
        key = revman .. "S1",
        action = 'RevmanSetStatusForCurrentPR "waiting_for_changes"',
        desc = "Set status for current PR to waiting for changes",
      }),
      cmd({
        key = revman .. "S2",
        action = 'RevmanSetStatusForCurrentPR "waiting_for_review"',
        desc = "Set status for current PR to waiting for review",
      }),
      cmd({
        key = revman .. "S3",
        action = 'RevmanSetStatusForCurrentPR "approved"',
        desc = "Set status for current PR to approved",
      }),
    },
  },
}

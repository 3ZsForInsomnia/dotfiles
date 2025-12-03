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

vim.keymap.set("i", "@", "@<C-x><C-o>", { silent = true, buffer = true })
vim.keymap.set("i", "#", "#<C-x><C-o>", { silent = true, buffer = true })

return {
  {
    "lewis6991/gitsigns.nvim",
    enabled = true,
    event = "LazyFile",
    opts = {
      sign_priority = 20,
    },
  },
  {
    "NeogitOrg/neogit",
    cmd = {
      "Neogit",
      "NeogitCommit",
      "NeogitRebase",
      "NeogitMerge",
      "NeogitLog",
      "NeogitBranch",
      "NeogitStash",
      "NeogitPull",
      "NeogitPush",
      "NeogitFetch",
      "NeogitDiff",
      "NeogitCherryPick",
      "NeogitLogCurrent",
      "NeogitResetState",
    },
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
        snacks = true,
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
    -- dir = "~/src/octo.nvim",
    "pwntester/octo.nvim",
    cmd = {
      "Octo",
      -- "OctoSearch",
      -- "OctoNotificationList",
      -- "OctoReview",
      -- "OctoPrBrowser",
      -- "OctoRepoBrowser",
      -- "OctoPrCreate",
      -- "OctoPrChecks",
      -- "OctoPrChanges",
      -- "OctoPrEdit",
      -- "OctoPrDiff",
      -- "OctoPrList",
      -- "OctoPrCheckout",
    },
    opts = {
      picker = "snacks",
      suppress_missing_scope = {
        projects_v2 = true,
      },
      notifications = {
        current_repo_only = true,
      },
      runs = {
        icons = {
          succeeded = "✓",
        },
      },
      mappings = {
        notification = {
          read = { lhs = "<C-r>", desc = "mark notification as read" },
        },
      },
    },
    config = function(_, opts)
      vim.treesitter.language.register("markdown", "octo")
      require("octo").setup(opts)
    end,
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
    -- "3ZsForInsomnia/revman.nvim",
    dir = "~/src/revman.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "kkharji/sqlite.lua",
      "pwntester/octo.nvim",
    },
    config = true,
    opts = {
      picker = "snacks",
      -- log_level = "info",
      data_retention_days = 0,
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
  {
    "topaxi/pipeline.nvim",
    keys = {
      cmd({ key = g .. "P", action = "Pipeline", desc = "Open pipeline.nvim" }),
    },
    build = "make",
    opts = {
      split = {
        position = "left",
      },
    },
  },
}

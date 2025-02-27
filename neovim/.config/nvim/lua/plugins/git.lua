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

return {
  {
    "NeogitOrg/neogit",
    event = "VeryLazy",
    opts = {
      graph_style = "unicode",
      process_spinner = true,
      initial_branch_name = "feat(pod1-",
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
      default_to_projects_v2 = true,
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
}

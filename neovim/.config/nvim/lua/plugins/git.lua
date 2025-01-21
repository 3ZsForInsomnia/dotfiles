local v = vim

_G.git_status_to_messages = function()
  local output = v.fn.system("git status")

  v.notify(output, v.log.levels.INFO)
end

local cmd = require("helpers").k_cmd
local n = function(command)
  return "Neogit " .. command
end
local g = "<leader>gn"

return {
  { "ruanyl/vim-gh-line", event = "VeryLazy" },
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
      cmd({
        key = g .. "s",
        action = "lua git_status_to_messages()",
        desc = "Status",
      }),
      cmd({
        key = g .. "c",
        action = n("commit"),
        desc = "Commit",
      }),
      cmd({
        key = g .. "r",
        action = n("rebase"),
        desc = "Rebase",
      }),
      cmd({
        key = g .. "m",
        action = n("merge"),
        desc = "Merge",
      }),
      cmd({
        key = g .. "l",
        action = n("log"),
        desc = "Log",
      }),
      cmd({
        key = g .. "b",
        action = n("branch"),
        desc = "Branch",
      }),
      cmd({
        key = g .. "t",
        action = n("stash"),
        desc = "Stash",
      }),
      cmd({
        key = g .. "p",
        action = n("pull"),
        desc = "Pull",
      }),
      cmd({
        key = g .. "u",
        action = n("push"),
        desc = "Push",
      }),
      cmd({
        key = g .. "f",
        action = n("fetch"),
        desc = "Fetch",
      }),
      cmd({
        key = g .. "d",
        action = n("diff"),
        desc = "Diff",
      }),
      cmd({
        key = g .. "a",
        action = n("cherry_pick"),
        desc = "Cherry pick",
      }),
    },
  },
}

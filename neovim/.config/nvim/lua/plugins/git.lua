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
      disable_signs = false,
      disable_hint = false,
      disable_context_highlighting = false,
      disable_commit_confirmation = false,
      auto_refresh = true,
      sort_branches = "-committerdate",
      disable_builtin_notifications = false,
      use_telescope = false,
      telescope_sorter = function()
        return require("telescope").extensions.fzf.native_fzf_sorter()
      end,
      use_magit_keybindings = false,
      kind = "split",
      console_timeout = 2000,
      auto_show_console = true,
      remember_settings = true,
      use_per_project_settings = true,
      ignored_settings = {},
      commit_popup = {
        kind = "split",
      },
      preview_buffer = {
        kind = "split",
      },
      popup = {
        kind = "split",
      },
      signs = {
        section = { ">", "v" },
        item = { ">", "v" },
        hunk = { "", "" },
      },
      integrations = {
        diffview = true,
      },
      sections = {
        untracked = {
          folded = true,
          hidden = false,
        },
        unstaged = {
          folded = true,
          hidden = false,
        },
        staged = {
          folded = true,
          hidden = false,
        },
        stashes = {
          folded = true,
          hidden = false,
        },
        unpulled = {
          hidden = false,
          folded = true,
        },
        unmerged = {
          hidden = false,
          folded = true,
        },
        recent = {
          folded = true,
          hidden = false,
        },
      },
    },
    keys = {
      cmd({
        key = g .. "s",
        action = n("status"),
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
  -- {
  --   "petertriho/cmp-git",
  --   dependencies = { "hrsh7th/nvim-cmp" },
  --   opts = {},
  --   -- init = function()
  --   --   table.insert(require("cmp").get_config().sources, { name = "git" })
  --   -- end,
  -- },
}

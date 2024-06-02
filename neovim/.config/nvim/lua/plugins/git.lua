return {
  { "ruanyl/vim-gh-line", event = "VeryLazy" },
  {
    "NeogitOrg/neogit",
    event = "VeryLazy",
    config = function()
      require("neogit").setup({
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
          },
          unstaged = {
            folded = true,
          },
          staged = {
            folded = true,
          },
          stashes = {
            folded = true,
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
          },
        },
      })
    end,
  }
}

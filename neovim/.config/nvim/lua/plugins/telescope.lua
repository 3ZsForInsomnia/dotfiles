local createShortcuts = function()
  local actions = require("telescope.actions")
  local open_with_trouble = require("trouble.sources.telescope").open

  return {
    ["<M-t>"] = open_with_trouble,
    ["<M-q>"] = actions.send_to_qflist + actions.open_qflist,
    ["<M-a>"] = actions.add_to_qflist + actions.open_qflist,
    ["<C-s>"] = actions.add_selection,
    ["<C-r>"] = actions.remove_selection,
    ["<M-d>"] = actions.drop_all,
    ["<M-s>"] = actions.select_all,
    ["<C-z>"] = actions.center,
    ["<C-w>"] = actions.which_key,
    ["<C-f>"] = actions.preview_scrolling_up,
    ["<C-b>"] = actions.preview_scrolling_down,
    ["<M-f>"] = actions.results_scrolling_up,
    ["<M-b>"] = actions.results_scrolling_down,
  }
end

local createOpts = function()
  local lga_actions = require("telescope-live-grep-args.actions")
  local icons = require("lazyvim.config").icons

  local shortcuts = createShortcuts()

  return {
    pickers = {
      find_files = {
        hidden = true,
        no_ignore = true,
        find_command = {
          "fd",
          "--color=never",
          "--type",
          "f",
          "--hidden",
          "--follow",
          "--no-ignore",
          "--exclude",
          ".luarc.json",
          "--exclude",
          "node_modules",
          "--exclude",
          ".git",
          "--exclude",
          "tags",
          "--exclude",
          "dist",
          "--exclude",
          ".DS_Store",
          "--exclude",
          "build",
          "--exclude",
          "out",
          "--exclude",
          ".next",
          "--exclude",
          "vim-sessions",
          "--exclude",
          ".vercel",
          "--exclude",
          ".netlify",
          "--exclude",
          "lcov-report",
          "--exclude",
          "__snapshots__",
          "--exclude",
          "lazy-lock.json",
          "--exclude",
          "lazyvim.json",
        },
      },
    },
    defaults = {
      file_ignore_patterns = {
        "node_modules",
        ".git/",
        "dist/",
        "build/",
        "target/",
        ".luarc.json",
        "__snapshots__",
        "lcov-report",
        ".next",
        "lazy-lock.json",
        "lazyvim.json",
      },
      prompt_prefix = icons.common.Telescope .. " " .. icons.misc.Carat .. " ",
      selection_caret = icons.common.Arrow .. " ",
      entry_prefix = icons.misc.Carat .. " ",
      multi_icon = " " .. icons.kinds.Array .. " ",
      wrap_results = true,
      sorting_strategy = "ascending",
      scroll_strategy = "limit",
      mappings = {
        i = shortcuts,
        n = shortcuts,
      },
      layout_config = {
        horizontal = {
          width = 0.95,
          height = 0.95,
          preview_width = 0.5,
        },
      },
      vimgrep_arguments = {
        "rg",
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--smart-case",
        "--hidden",
      },
    },
    extensions = {
      fzf = {
        fuzzy = true,                   -- false will only do exact matching
        override_generic_sorter = true, -- override the generic sorter
        override_file_sorter = true,    -- override the file sorter
        case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
      },
      bookmarks = {
        selected_browser = "chrome",
        -- Either provide a shell command to open the URL
        url_open_command = "open",
        -- Show the full path to the bookmark instead of just the bookmark name
        full_path = true,
        -- Add a column which contains the tags for each bookmark for buku
        buku_include_tags = false,
        -- Provide debug messages
        debug = false,
      },
      heading = {
        treesitter = true,
      },
      live_grep_args = {
        auto_quoting = true,
        mappings = {
          i = {
            ["<C-k>"] = lga_actions.quote_prompt(),
            ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
          },
        },
      },
    },
  }
end

local loadExtensions = function(load_extension)
  load_extension("fzf")
  load_extension("live_grep_args")
  load_extension("changes")
  load_extension("file_browser")
  load_extension("luasnip")
  load_extension("scriptnames")
  load_extension("heading")
  load_extension("frecency")
  load_extension("http")
  load_extension("tailiscope")
  load_extension("undo")
  load_extension("angular")
  load_extension("noice")
  load_extension("gpt")
  load_extension("conflicts")
  load_extension("persisted")
end

return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = {
      "nvim-telescope/telescope-live-grep-args.nvim",
      "nvim-telescope/telescope-frecency.nvim",
      "benfowler/telescope-luasnip.nvim",
      "barrett-ruth/telescope-http.nvim",
      "danielvolchek/tailiscope.nvim",
      "LinArcX/telescope-changes.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        run = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake"
            .. "--build build --config Release && cmake --install build --prefix build",
      },
      "3ZsForInsomnia/telescope-angular",
      "dhruvmanila/telescope-bookmarks.nvim",
      "debugloop/telescope-undo.nvim",
      "LinArcX/telescope-scriptnames.nvim",
      "crispgm/telescope-heading.nvim",
      "nvim-telescope/telescope-file-browser.nvim",
      "HPRIOR/telescope-gpt",
      "Snikimonkd/telescope-git-conflicts.nvim",
      "olimorris/persisted.nvim",
    },
    config = function()
      local telescope = require("telescope")
      local opts = createOpts()

      telescope.setup(opts)

      loadExtensions(telescope.load_extension)
    end,
  },
}

local cmd = require("helpers").k_cmd

local t = function(command)
  return "Telescope " .. command
end

local f = "<leader>f"

local createShortcuts = function()
  local actions = require("telescope.actions")
  local open_with_trouble = require("trouble.sources.telescope").open
  local lg_actions = require("telescope-live-grep-args.actions")

  local function quote_prompt(prompt_bufnr)
    lg_actions.quote_prompt()(prompt_bufnr)
  end
  local function quote_prompt_glob(prompt_bufnr)
    lg_actions.quote_prompt({ postfix = " --glob '**//**'" })(prompt_bufnr)
  end
  local function quote_prompt_iglob(prompt_bufnr)
    lg_actions.quote_prompt({ postfix = " --glob !**//**" })(prompt_bufnr)
  end
  local function find_by_type(prompt_bufnr)
    lg_actions.quote_prompt({ postfix = " -t" })(prompt_bufnr)
  end

  return {
    -- Search window mappings
    ["<M-t>"] = open_with_trouble,
    ["<M-q>"] = actions.add_to_qflist,
    ["<M-a>"] = actions.add_selection,
    ["<M-r>"] = actions.remove_selection,
    ["<M-A>"] = actions.select_all,
    ["<M-R>"] = actions.drop_all,
    ["<M-f>"] = actions.results_scrolling_up,
    ["<M-b>"] = actions.results_scrolling_down,

    -- Preview window mappings
    ["<M-w>"] = actions.which_key,
    ["<M-z>"] = actions.center,
    ["<M-u>"] = actions.preview_scrolling_up,
    ["<M-d>"] = actions.preview_scrolling_down,

    -- Search input mappings
    ["<C-k>"] = quote_prompt,
    ["<C-g>"] = quote_prompt_glob,
    ["<C-i>"] = quote_prompt_iglob,
    ["<C-t>"] = find_by_type,
    ["<C-f>"] = actions.to_fuzzy_refine,
  }
end

local createOpts = function()
  local actions = require("telescope.actions")
  local icons = require("lazyvim.config").icons

  local shortcuts = createShortcuts()

  local function quote_prompt(prompt_bufnr)
    require("telescope-live-grep-args.actions").quote_prompt()(prompt_bufnr)
  end
  local function quote_prompt_glob()
    require("telescope-live-grep-args.actions").quote_prompt({ postfix = " --glob " })()
  end
  local function quote_prompt_iglob()
    require("telescope-live-grep-args.actions").quote_prompt({ postfix = " --glob " })()
  end

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
          "--exclude",
          ".local",
          "--exclude",
          "share",
          "--exclude",
          "\\.venv",
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
        "package-lock.json",
        ".coverage",
        ".repro",
        ".nx",
        "\\.venv",
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
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--smart-case",
        "--hidden",
        "--no-ignore",
        "--glob=!tags", -- Exclude tags file from search
      },
    },
    extensions = {
      fzf = {
        fuzzy = true,
        override_generic_sorter = true,
        override_file_sorter = true,
        case_mode = "smart_case",
      },
      heading = {
        treesitter = true,
      },
      live_grep_args = {
        auto_quoting = true,
        mappings = {
          i = {
            ["<C-k>"] = quote_prompt,
            ["<C-i>"] = quote_prompt_glob,
            ["<C-I>"] = quote_prompt_iglob,
            ["<C-space>"] = actions.to_fuzzy_refine,
          },
          n = {
            ["<C-k>"] = quote_prompt,
            ["<C-i>"] = quote_prompt_glob,
            ["<C-I>"] = quote_prompt_iglob,
            ["<C-space>"] = actions.to_fuzzy_refine,
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
  load_extension("undo")
  load_extension("angular")
  load_extension("noice")
  load_extension("gpt")
  load_extension("conflicts")
  load_extension("persisted")
  load_extension("bookmarks")
  load_extension("ui-select")
  load_extension("adjacent")
end

return {
  {
    "dhruvmanila/browser-bookmarks.nvim",
    version = "*",
    lazy = true,
    opts = {
      selected_browser = "chrome",
    },
  },
  {
    "axkirillov/easypick.nvim",
    cmd = "Easypick",
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      local easypick = require("easypick")
      local chatLocation = "~/.local/share/nvim/copilotchat_history"

      easypick.setup({
        pickers = {
          {
            name = "copilot_chats",
            command = "fd . " .. chatLocation .. " | awk -F/ '{print $NF}' | sed 's/\\.json$//'",
            previewer = function(selected)
              local full_path = vim.fn.expand(chatLocation .. "/" .. selected .. ".json")

              return {
                command = "cat " .. full_path,
                cwd = nil,
              }
            end,
            -- previewer = function(selected)
            --   local full_path = vim.fn.expand(chatLocation .. "/" .. selected .. ".json")
            --
            --   return {
            --     command = "cat "
            --       .. full_path
            --       .. ' | jq -r \'.messages[] | "\\n## " + (.role | if . == "user" then "Me" else "Copilot" end) + ":\\n\\n" + .content\'',
            --     cwd = nil,
            --   }
            -- end,
            action = function(selection)
              vim.cmd("CopilotChatLoad " .. selection.value)
              vim.cmd("CopilotChatOpen")
            end,
          },
          {
            name = "changed_files",
            command = "git diff --name-only $(git merge-base HEAD main)",
            previewer = easypick.previewers.branch_diff({ base_branch = "main" }),
          },
        },
      })
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    tag = "0.1.8",
    dependencies = {
      "MaximilianLloyd/adjacent.nvim",
      "benfowler/telescope-luasnip.nvim",
      "LinArcX/telescope-changes.nvim",
      "3ZsForInsomnia/telescope-angular",
      "debugloop/telescope-undo.nvim",
      "LinArcX/telescope-scriptnames.nvim",
      "crispgm/telescope-heading.nvim",
      "nvim-telescope/telescope-file-browser.nvim",
      "HPRIOR/telescope-gpt",
      "Snikimonkd/telescope-git-conflicts.nvim",
      "olimorris/persisted.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
      { "barrett-ruth/http-codes.nvim", config = true },
      { "nvim-telescope/telescope-live-grep-args.nvim", version = "^1.0.0" },
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        run = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake"
          .. "--build build --config Release && cmake --install build --prefix build",
      },
    },
    config = function()
      local telescope = require("telescope")
      local opts = createOpts()

      telescope.setup(opts)
      loadExtensions(telescope.load_extension)
    end,
    keys = function()
      return {
        cmd({
          key = f .. "a",
          action = t("adjacent"),
          desc = "Search files adjacent to current file",
        }),
        cmd({
          key = f .. "s",
          action = "lua require('telescope-live-grep-args.shortcuts').grep_word_under_cursor()",
          desc = "Grep word under cursor",
        }),
        cmd({
          key = f .. "j",
          action = "lua require('telescope').extensions.live_grep_args.live_grep_args()",
          desc = "Live grep",
        }),
        cmd({
          key = f .. "v",
          action = "lua require('telescope-live-grep-args.shortcuts').grep_visual_selection()",
          desc = "Live grep of visual selection",
          mode = "v",
        }),
        cmd({
          key = f .. "f",
          action = t("find_files"),
          desc = "Files",
        }),
        cmd({
          key = f .. "h",
          action = t("search_history"),
          desc = "Search history",
        }),
        cmd({
          key = f .. "r",
          action = t("resume"),
          desc = "Resume previous search",
        }),

        --
        -- Obsidian
        --
        cmd({
          key = f .. "o",
          action = "Obsidian search",
          desc = "Search notes",
        }),

        --
        -- Changes, loc and qf lists
        --
        cmd({
          key = f .. "cc",
          action = t("changes"),
          desc = "Changes",
        }),
        cmd({
          key = f .. "cu",
          action = t("undo"),
          desc = "Undo tree",
        }),
        cmd({
          key = f .. "cf",
          action = t("quickfix"),
          desc = "Quickfix",
        }),
        cmd({
          key = f .. "ch",
          action = t("quickfixhistory"),
          desc = "Quickfix history",
        }),
        cmd({
          key = f .. "cj",
          action = t("jumplist"),
          desc = "Jumplist",
        }),
        cmd({
          key = f .. "cl",
          action = t("loclist"),
          desc = "Location list",
        }),

        --
        -- Buffers, tags and marks
        --
        cmd({
          key = f .. "bm",
          action = t("marks"),
          desc = "Marks",
        }),
        cmd({
          key = f .. "bb",
          action = t("buffers"),
          desc = "Buffers",
        }),
        cmd({
          key = f .. "br",
          action = t("registers"),
          desc = "Registers",
        }),
        cmd({
          key = f .. "bt",
          action = t("tags"),
          desc = "Tags",
        }),

        --
        -- Git
        --
        cmd({
          key = f .. "gs",
          action = t("git_status"),
          desc = "Status",
        }),
        cmd({
          key = f .. "gc",
          action = t("git_commits"),
          desc = "Commits",
        }),
        cmd({
          key = f .. "gb",
          action = t("git_branches"),
          desc = "Branches",
        }),
        cmd({
          key = f .. "gh",
          action = "Easypick changed_files",
          desc = "Changed files",
        }),
        cmd({
          key = f .. "gt",
          action = t("git_stash"),
          desc = "Stashes",
        }),
        cmd({
          key = f .. "gu",
          action = t("git_bcommits"),
          desc = "Commits in buffer",
        }),
        cmd({
          key = f .. "gf",
          action = t("git_files"),
          desc = "Files",
        }),

        --
        -- Documentation
        --
        cmd({
          key = f .. "da",
          action = "Easypick copilot_chats",
          desc = "Copilot chats",
        }),
        cmd({
          key = f .. "dd",
          action = "DevdocsOpen",
          desc = "Devdocs",
        }),
        cmd({
          key = f .. "dt",
          action = "DevdocsOpen tailwindcss",
          desc = "Tailwind",
        }),
        -- not sure why this didn't work with the `k` helper
        vim.api.nvim_set_keymap("n", "<leader>fdo", ":DevdocsOpen ", { noremap = true, silent = true }),
        cmd({
          key = f .. "ds",
          action = t("luasnip"),
          desc = "Snippets",
        }),
        cmd({
          key = f .. "dm",
          action = t("man_pages"),
          desc = "Man pages",
        }),
        cmd({
          key = f .. "dh",
          action = "HTTPCodes",
          desc = "Http Codes",
        }),
        cmd({
          key = f .. "dH",
          action = t("help_tags"),
          desc = "Help tags",
        }),
        cmd({
          key = f .. "db",
          action = t("bookmarks"),
          desc = "Chrome Bookmarks",
        }),
        cmd({
          key = f .. "dk",
          action = t("keymaps"),
          desc = "Keymaps",
        }),

        --
        -- LSP
        --
        cmd({
          key = f .. "lr",
          action = t("lsp_references"),
          desc = "References",
        }),
        cmd({
          key = f .. "li",
          action = t("lsp_incoming_calls"),
          desc = "Incoming calls",
        }),
        cmd({
          key = f .. "lo",
          action = t("lsp_outgoing_calls"),
          desc = "Outgoing calls",
        }),
        cmd({
          key = f .. "ls",
          action = t("lsp_document_symbols"),
          desc = "Document symbols",
        }),
        cmd({
          key = f .. "lt",
          action = t("lsp_workspace_symbols"),
          desc = "Workspace symbols",
        }),
        cmd({
          key = f .. "ld",
          action = t("lsp_definitions"),
          desc = "Definitions",
        }),
        cmd({
          key = f .. "lm",
          action = t("lsp_implentations"),
          desc = "Implementations",
        }),
        cmd({
          key = f .. "lt",
          action = t("lsp_type_definitions"),
          desc = "Type definitions",
        }),
        -- k({
        --   key = f .. "lD",
        --   action = 'lua require("trouble.providers.telescope").open_with_trouble()',
        --   desc = "Show diagnostics",
        -- }),

        --
        -- Misc
        --
        cmd({
          key = f .. "mn",
          action = t("scriptnames"),
          desc = "Scriptnames",
        }),
        cmd({
          key = f .. "mh",
          action = t("heading"),
          desc = "Headings",
        }),
        cmd({
          key = f .. "ma",
          action = t("angular"),
          desc = "Angular modules",
        }),
        cmd({
          key = f .. "mc",
          action = "TodoTelescope",
          desc = "Todo",
        }),
        cmd({
          key = f .. "my",
          action = "Easypick clipboard",
          desc = "Clipboard",
        }),
        cmd({
          key = f .. "ms",
          action = t("persisted"),
          desc = "Sessions",
        }),
      }
    end,
  },
}

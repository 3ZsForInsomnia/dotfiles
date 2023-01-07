local telescope = require("telescope")
local actions = require("telescope.actions")
local trouble = require("trouble.providers.telescope")

telescope.setup {
  defaults = {
    wrap_results = true,
    sorting_strategy = "ascending",
    mappings = {
      i = { ["<c-s>"] = trouble.open_with_trouble },
      n = { ["<c-s>"] = trouble.open_with_trouble },
    },
    layout_config = {
      horizontal = {
        width = 0.95,
        height = 0.95,
        preview_width = 0.5
      }
    },
    vimgrep_arguments = {
      'rg',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case',
      '--hidden',
    },
  },
  extensions = {
    fzf = {
      fuzzy = true, -- false will only do exact matching
      override_generic_sorter = true, -- override the generic sorter
      override_file_sorter = true, -- override the file sorter
      case_mode = "smart_case", -- or "ignore_case" or "respect_case"
      -- the default case_mode is "smart_case"
    },
    bookmarks = {
      selected_browser = 'chrome',
      -- Either provide a shell command to open the URL
      url_open_command = 'open',
      -- Show the full path to the bookmark instead of just the bookmark name
      full_path = true,
      -- Add a column which contains the tags for each bookmark for buku
      buku_include_tags = false,
      -- Provide debug messages
      debug = false,
    },
  },
  xray23 = {
    sessionDir = "~/vim-sessions",
  },
  heading = {
    treesitter = true,
  },
}

require "telescope-tabs".setup()

telescope.load_extension('fzf')
telescope.load_extension('bookmarks')
telescope.load_extension('changes')
telescope.load_extension("xray23")
telescope.load_extension("dash")
telescope.load_extension('luasnip')
telescope.load_extension('scriptnames')
telescope.load_extension('heading')
telescope.load_extension("packer")
telescope.load_extension("frecency")
telescope.load_extension("http")
telescope.load_extension("tailiscope")
telescope.load_extension("undo")

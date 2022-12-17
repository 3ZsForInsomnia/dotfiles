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
}

telescope.load_extension('fzf')
telescope.load_extension('bookmarks')
telescope.load_extension('changes')
telescope.load_extension("xray23")
telescope.load_extension("dash")

require('telescope-alternate').setup({
  mappings = {
    -- { 'app/services/(.*)_services/(.*).rb', { -- alternate from services to contracts / models
    --   { 'app/contracts/[1]_contracts/[2].rb', 'Contract' }, -- Adding label to switch
    --   { 'app/models/**/*[1].rb', 'Model', true }, -- Ignore create entry (with true)
    -- } },
    -- { 'app/contracts/(.*)_contracts/(.*).rb', { { 'app/services/[1]_services/[2].rb', 'Service' } } }, -- from contracts to services
    -- Search anything on helper folder that contains pluralize version of model.
    --Example: app/models/user.rb -> app/helpers/foo/bar/my_users_helper.rb
    -- { 'app/models/(.*).rb', { { 'db/helpers/**/*[1:pluralize]*.rb', 'Helper' } } },
    -- { 'app/**/*.rb', { { 'spec/[1].rb', 'Test' } } }, -- Alternate between file and test
  },
  -- transformers = { -- custom transformers
  --   change_to_uppercase = function(w) return my_uppercase_method(w) end
  -- }
})

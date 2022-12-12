local dashConfig = require('libdash_nvim').default_config
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
    dash = dashConfig
  }
}

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


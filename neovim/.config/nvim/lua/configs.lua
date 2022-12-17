-- General setup of things not worth their own file
require('refactoring').setup({})

-- Source custom lua functions
require('save-restore-session')

-- Source all plugin configs
require('config.telescope')
require('config.cmp-and-lsp')
require('config.marks')
require('config.null-ls')
-- require('config.screenshot')
require('config.telescope')
require('config.treesitter')
require('config.statusline')
require('config.whichkey')
require('config.indent')
require('config.dash')

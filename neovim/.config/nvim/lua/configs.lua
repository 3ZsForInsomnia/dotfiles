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
require('config.alternate')
require('config.file-explorer')
require('config.theming')
require('config.markdown-preview-config')
require('config.trello')
require('config.luasnip')

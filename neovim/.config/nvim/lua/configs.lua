-- General setup of things not worth their own file
require('refactoring').setup({})
require("trouble").setup {
  height = 20,
  action_keys = {
    open_tab = { "<c-t>" },
  },
}
require('hlargs').setup({
  paint_catch_blocks = {
    declarations = true,
    usages = true,
  },
})
require('regexplainer').setup()
require('cmp_luasnip_choice').setup({
  auto_open = true,
})
require("todo-comments").setup()
require("figlet").Config({ font = "3d" })
require('Comment').setup()
require("nvim-highlight-colors").setup {
  render = 'background',
  enable_named_colors = true,
  enable_tailwind = true
}
require("twilight").setup()
require('package-info').setup()
require('gitsigns').setup()
require "octo".setup()
require('prettier').setup({
  bin = 'prettierd',
})

-- Source custom lua functions
require('save-restore-session')

-- Source all plugin configs
require('config.telescope')
require('config.cmp-and-lsp')
require('config.marks')
require('config.null-ls')
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
require('config.hlargs')

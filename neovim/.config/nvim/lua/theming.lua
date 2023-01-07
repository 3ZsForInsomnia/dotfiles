local o = vim.o

o.cmdheight = 2
o.updatetime = 100
o.cursorline = true
o.expandtab = true
o.shiftwidth = 2
o.tabstop = 2
o.softtabstop = 2
o.termguicolors = true
o.relativenumber = true
o.number = true
o.smartindent = true
o.ignorecase = true
o.smartcase = true
o.showbreak = '↳ '
o.showmode = true
o.foldmethod = 'expr'
o.foldexpr = 'nvim_treesitter#foldexpr()'
o.foldlevelstart = 6
o.completeopt = 'menu,noinsert,menuone,noselect,preview'
vim.opt.shortmess:append('c')
vim.cmd('colorscheme moonfly')
vim.cmd('syntax sync fromstart')

vim.api.nvim_create_autocmd('ModeChanged', {
  callback = function()
    local mode = vim.api.nvim_get_mode().mode
    local colorsForLineNumbers = {
      ['i'] = '#7aa2f7',
      ['c'] = '#e0af68',
      ['v'] = '#c678dd',
      ['V'] = '#c678dd',
      [''] = '#c678dd'
    }
    vim.api.nvim_set_hl(0, 'CursorLineNr', {
      foreground = colorsForLineNumbers[mode] or '#737aa2'
    })
    if mode == 'c' then
      vim.api.nvim_set_hl(0, 'MsgArea', {
        foreground = colorsForLineNumbers[mode]
      })
    else
      vim.api.nvim_set_hl(0, 'MsgArea', {
        foreground = "#cccccc"
      })
    end
  end,
})

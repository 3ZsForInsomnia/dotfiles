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

vim.cmd [[
syntax sync fromstart
colorscheme moonfly

" -- Ensures syntax highlighting from TS works for tsx files
augroup SyntaxSettings
  autocmd!
  autocmd BufNewFile,BufRead *.tsx o.filetype=typescript.typescriptreact
augroup END

" -- Highlight on yank
au TextYankPost * silent! lua vim.highlight.on_yank({timeout=333})
]]

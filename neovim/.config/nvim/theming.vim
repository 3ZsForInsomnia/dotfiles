set cmdheight=2
set hlsearch
set cursorline
set autoindent
set expandtab
set shiftwidth=2
set sw=2
set tabstop=2
set softtabstop=2
set termguicolors
set t_Co=256
set relativenumber
set number
set smartindent
set smartcase
set ignorecase
let &showbreak = '↳ '
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
set foldlevelstart=20

syntax on
syntax sync fromstart

" Ensures syntax highlighting from TS works for tsx files
augroup SyntaxSettings
  autocmd!
  autocmd BufNewFile,BufRead *.tsx set filetype=typescript.typescriptreact
augroup END

au TextYankPost * silent! lua vim.highlight.on_yank()

colorscheme moonfly
let g:chadtree_settings = {'theme.text_colour_set': 'trapdoor'}
highlight SpellBad guisp='DarkRed' gui=undercurl cterm=undercurl

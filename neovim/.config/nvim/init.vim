lua require('impatient')
source ~/.config/nvim/theming.vim
lua require('plugins')
source ~/.config/nvim/markdown-preview-config.vim
lua require('configs')
lua require('keys')

set noswapfile
set spell
set spelllang=en_us
set spelloptions=camel
set spellfile=~/.config/nvim/spell/.utf-8.add
set nocompatible
filetype plugin on
let mapleader=" "
set backup
set backupdir=~/.vim/tmp
set dir=~/.vim/tmp
set undofile
set undodir=~/.vim/undo
set showmode
set hidden
set updatetime=300
set mouse=
set notagrelative
set completeopt=menu,noinsert,menuone,noselect,preview
set shortmess+=c
" Enables reading vimrc in folder where vim is opened
set exrc
" Ensures other vimrc files cannot write/do more than set variables and whatnot
set secure

let g:python3_host_prog = "/usr/bin/python3"
let g:python_host_prog = "/usr/bin/python"
let g:instant_username = 'Zach'
let g:UltiSnipsEditSplit='tabdo'
let g:blamer_enabled = 1
let g:db_ui_save_location = '~/.config/db_ui'
let g:matchup_matchparen_offscreen = {'method': 'popup'}

source ~/.config/nvim/trello.vim

cmap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'

autocmd User TelescopePreviewerLoaded setlocal wrap
autocmd BufWinEnter,WinEnter term://* set filetype=zsh
au TermOpen * setlocal nospell | :startinsert

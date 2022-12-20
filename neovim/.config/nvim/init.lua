local o = vim.opt
local g = vim.g

g.mapleader = " "
o.spell = true
o.spelllang='en_us'
o.spelloptions='camel'
o.spellfile='/Users/zachary.levine/.config/nvim/spell/.utf-8.add'
o.backup = true
o.backupdir = '/Users/zachary.levine/.local/state/nvim/backup//'
o.undofile = true
o.mouse=''
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1
-- Enables reading vimrc in folder where vim is opened
o.exrc = true
-- Ensures other vimrc files cannot write/do more than o.variables and whatnot
o.secure = true

require('impatient')
require('plugins')
require('configs')
require('keys')

g.python3_host_prog = "/usr/bin/python3"
g.python_host_prog = "/usr/bin/python"
g.instant_username = 'Zach'
g.UltiSnipsEditSplit='tabdo'
g.blamer_enabled = 1
g.db_ui_save_location = '~/.config/db_ui'
g.matchup_matchparen_offscreen = { method = "popup" }

vim.cmd [[
set noswapfile
set notagrelative
cmap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'

autocmd User TelescopePreviewerLoaded setlocal wrap
autocmd BufWinEnter,WinEnter term://* o.filetype=zsh
au TermOpen * setlocal nospell | :startinsert
]]

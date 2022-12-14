local o = vim.opt
local g = vim.g
local a = vim.api

g.mapleader = " "
o.spell = true
o.spelllang = 'en_us'
o.spelloptions = 'camel'
o.spellfile = '/Users/zachary.levine/.config/nvim/spell/.utf-8.add'
o.backup = true
o.backupdir = '/Users/zachary.levine/.local/state/nvim/backup//'
o.undofile = true
o.lazyredraw = true
o.mouse = ''
o.grepprg='rg --vimgrep --no-heading'
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
g.blamer_enabled = 1
g.db_ui_save_location = '~/.config/db_ui'
g.matchup_matchparen_offscreen = { method = "popup" }
g.mkdp_filetypes = { "markdown" }

-- Just putting luasnip keybinds here since they won't be shown by whichkey since they aren't normal mode
a.nvim_set_keymap("i", "<C-j>", "<Plug>luasnip-next-choice", {})
a.nvim_set_keymap("s", "<C-j>", "<Plug>luasnip-next-choice", {})
a.nvim_set_keymap("i", "<C-k>", "<Plug>luasnip-prev-choice", {})
a.nvim_set_keymap("s", "<C-k>", "<Plug>luasnip-prev-choice", {})
a.nvim_set_keymap("s", "<C-e>", "<Plug>luasnip-expand-snippet", {})
a.nvim_set_keymap("i", "<C-e>", "<Plug>luasnip-expand-snippet", {})

vim.cmd [[
set noswapfile
set notagrelative

cmap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'
inoremap <c-l> <cmd>lua require("luasnip.extras.select_choice")()<cr>

autocmd User TelescopePreviewerLoaded setlocal wrap
autocmd BufWinEnter,WinEnter term://* setlocal filetype=zsh
au TermOpen * setlocal nospell | :startinsert
]]

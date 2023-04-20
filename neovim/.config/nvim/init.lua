local o = vim.opt
local g = vim.g

g.mapleader = " "
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1
g.notagrelative = true

o.spell = true
o.spelllang = 'en_us'
o.spelloptions = 'camel'
o.spellfile = '/home/zach/.config/nvim/spell/.utf-8.add'
o.backup = true
o.backupdir = '/home/zach/.local/state/nvim/backup//'
o.undofile = true
o.lazyredraw = true
o.mouse = ''
o.grepprg = 'rg --vimgrep --no-heading'
-- Enables reading vimrc in folder where vim is opened
o.exrc = true
-- Ensures other vimrc files cannot write/do more than o.variables and whatnot
o.secure = true

require('impatient')
require('theming')
require('plugins')
require('keys')
require('autocommands')
require('save-restore-session')
vim.cmd [[ packadd cfilter ]]

g.python3_host_prog = "/usr/bin/python3"
g.python_host_prog = "/usr/bin/python"
g.instant_username = 'Zach'
g.db_ui_save_location = '~/.config/db_ui'
g.matchup_matchparen_offscreen = { method = "popup" }
g.mkdp_filetypes = { "markdown" }

local function pathExpand()
  if vim.fn.getcmdtype() == ':' then
    return vim.fn.expand('%:h') .. '/'
  else
    return '%%'
  end
end

vim.keymap.set("c", "%%", function() return pathExpand() end, { expr = true })

-- require('pomo.pomo')

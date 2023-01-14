local o = vim.opt
local g = vim.g
local k = vim.api.nvim_set_keymap

g.mapleader = " "
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1
g.notagrelative = true

o.spell = true
o.spelllang = 'en_us'
o.spelloptions = 'camel'
o.spellfile = '/Users/zachary.levine/.config/nvim/spell/.utf-8.add'
o.backup = true
o.backupdir = '/Users/zachary.levine/.local/state/nvim/backup//'
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

g.python3_host_prog = "/usr/bin/python3"
g.python_host_prog = "/usr/bin/python"
g.instant_username = 'Zach'
g.db_ui_save_location = '~/.config/db_ui'
g.matchup_matchparen_offscreen = { method = "popup" }
g.mkdp_filetypes = { "markdown" }

-- Just putting luasnip keybinds here since they won't be shown by whichkey since they aren't normal mode
k("i", "<C-j>", "<Plug>luasnip-next-choice", {})
k("s", "<C-j>", "<Plug>luasnip-next-choice", {})
k("i", "<C-k>", "<Plug>luasnip-prev-choice", {})
k("s", "<C-k>", "<Plug>luasnip-prev-choice", {})
k("s", "<C-e>", "<Plug>luasnip-expand-snippet", {})
k("i", "<C-e>", "<Plug>luasnip-expand-snippet", {})
k("i", "<C-l>", "<cmd>lua require('luasnip.extras.select_choice')()<cr>", {})

local function pathExpand()
  if vim.fn.getcmdtype() == ':' then
    return vim.fn.expand('%:h') .. '/'
  else
    return '%%'
  end
end

vim.keymap.set("c", "%%",
  function() return pathExpand() end,
  { expr = true }
)

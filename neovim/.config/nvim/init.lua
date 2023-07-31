local v = vim
local o = v.opt
local g = v.g

g.mapleader = " "
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1
g.notagrelative = true

o.spell = true
o.spelllang = "en_us"
o.spelloptions = "camel"
o.spellfile = "/Users/zachary/.config/nvim/spell/.utf-8.add"
o.swapfile = false
o.backup = true
o.backupdir = "/Users/zachary/.local/state/nvim/backup//"
o.undofile = true
o.lazyredraw = true
o.mouse = ""
o.grepprg = "rg --vimgrep --no-heading"
-- Enables reading vimrc in folder where vim is opened
o.exrc = true
-- Ensures other vimrc files cannot write/do more than o.variables and whatnot
o.secure = true
o.shada = "!,'100,<50,s10,h"

o.timeoutlen = 500
o.timeout = true

v.loader.enable()
require("theming")
require("plugins")
require("autocommands")
require("keys")
require("save-restore-session")
v.cmd([[ packadd cfilter ]])

g.python3_host_prog = "/usr/bin/python3"
g.instant_username = "Zach"
g.db_ui_save_location = "~/.config/db_ui"
g.matchup_matchparen_offscreen = { method = "popup" }
g.mkdp_filetypes = { "markdown" }

local function pathExpand()
  if v.fn.getcmdtype() == ":" then
    return v.fn.expand("%:h") .. "/"
  else
    return "%%"
  end
end

v.keymap.set("c", "%%", function()
  return pathExpand()
end, { expr = true })

-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local v = vim
local o = v.opt
local g = v.g
local c = v.cmd
local a = v.api
local h = a.nvim_set_hl

local home = v.fn.expand("$HOME") .. "/"

c([[
  set shortmess +=S
]])

o.foldcolumn = "5"
o.numberwidth = 4
o.foldmethod = "manual"
o.foldlevel = 99
o.foldlevelstart = 99
o.foldenable = true
o.fillchars = {
  foldopen = "󰅀",
  foldclose = "󰅂",
  fold = "",
  foldsep = "|",
  diff = "/",
  eob = "󰑀",
}

o.softtabstop = 2
o.showbreak = "↳ "
g.notagrelative = true

o.backup = true
o.backupdir = home .. ".local/state/nvim/backup//"
o.shada = "!,'100,<50,s10,h"
o.shadafile = home .. ".local/state/nvim/vim-sessions/main.shada"

o.spell = true
o.spelllang = "en_us"
o.spellfile = home .. ".config/nvim/spell/.utf-8.add"
o.spelloptions = "camel,noplainbuffer"

o.swapfile = false
o.grepprg = "rg --vimgrep --no-heading"
o.exrc = true -- Enables reading vimrc in folder where vim is opened
o.secure = true -- Ensures other vimrc files cannot write/do more than o.variables and whatnot

o.timeout = true
o.timeoutlen = 300
o.ttimeoutlen = 10
o.updatetime = 300

o.wrap = true
o.breakindent = true
o.showbreak = "󱞩" .. string.rep(" ", 3) -- Make it so that long lines wrap smartly

c([[ packadd cfilter ]])

g.python3_host_prog = "/usr/bin/python3"
g.instant_username = "Zach"
g.db_ui_save_location = "~/.config/db_ui"
g.matchup_matchparen_offscreen = { method = "popup" }

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

c("highlight SpellBad guisp=DarkRed gui=undercurl cterm=undercurl")

-- Default search formatting
local searchBgInactive = "#ffff54"
local searchBgActive = "#fe9a4a"
local searchFg = "#000000"
local cursorLine = "#666666"
h(0, "Search", {
  background = searchBgInactive,
  foreground = searchFg,
})
h(0, "IncSearch", {
  background = searchBgActive,
  foreground = searchFg,
})
h(0, "CurSearch", {
  background = searchBgActive,
  foreground = searchFg,
})

-- Default line number
h(0, "LineNr", {
  foreground = cursorLine,
})

-- Default Cursor Line
h(0, "CursorLineNr", {
  foreground = "#00ffff",
  bold = true,
})
h(0, "CursorLineFold", {
  background = cursorLine,
})
h(0, "CursorLineSign", {
  background = "#343434",
})

v.diagnostic.config({
  float = { border = "single" },
  signs = { priority = 10 },
})

-- Overrides of LazyVim options
o.clipboard = ""
o.mouse = ""
o.completeopt = "menu,noinsert,menuone,noselect,preview"

g.lazyvim_picker = "snacks"
g.autoformat = false

v.filetype.add({
  extension = {
    ["http"] = "http",
  },
})

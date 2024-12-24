-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local v = vim
local o = v.opt
local g = v.g
local c = v.cmd
local a = v.api
local h = a.nvim_set_hl

o.fillchars = {
  foldopen = "󰅀",
  foldclose = "󰅂",
  fold = "",
  foldsep = "|",
  diff = "/",
  eob = "󰑀",
}
o.signcolumn = "yes:4"
o.numberwidth = 5
o.foldcolumn = "5"
o.foldlevelstart = 7
o.statuscolumn = "%C%s  %{v:relnum?v:relnum:v:lnum} "

o.softtabstop = 2
o.showbreak = "↳ "
g.notagrelative = true

o.backup = true
-- o.backupdir = "/home/zach/.local/state/nvim/backup//"
o.backupdir = "/Users/zacharylevine/.local/state/nvim/backup//"
o.shada = "!,'100,<50,s10,h"
-- o.shadafile = "/home/zach/vim-sessions/main.shada"
o.shadafile = "/Users/zacharylevine/.local/state/nvim/vim-sessions/main.shada"

o.spell = true
o.spelllang = "en_us"
-- o.spellfile = "/home/zach/.config/nvim/spell/.utf-8.add"
o.spellfile = "/Users/zacharylevine/.config/nvim/spell/.utf-8.add"
o.spelloptions = "camel,noplainbuffer"

o.swapfile = false
o.grepprg = "rg --vimgrep --no-heading"
-- Enables reading vimrc in folder where vim is opened
o.exrc = true
-- Ensures other vimrc files cannot write/do more than o.variables and whatnot
o.secure = true

o.timeout = true
o.timeoutlen = 300
o.updatetime = 75

o.wrap = true

-- require("keys")
-- require("save-restore-session")
c([[ packadd cfilter ]])

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
})

-- Markdown settings
g.mkdp_auto_close = 1
g.mkdp_refresh_slow = 1
g.gmkdp_refresh_slow = 1
g.mkdp_command_for_global = 1
g.mkdp_open_to_the_world = 0
g.mkdp_browser = "Google Chrome"
g.mkdp_echo_preview_url = 1
g.mkdp_preview_options = {
  mkit = {},
  katex = {},
  uml = {},
  maid = {},
  disable_sync_scroll = 0,
  sync_scroll_type = "middle",
  hide_yaml_meta = 1,
  sequence_diagrams = {},
  flowchart_diagrams = {},
}
g.mkdp_port = "7777"
g.mkdp_page_title = "「${name}」"

-- Overrides of LazyVim options
o.clipboard = ""
o.completeopt = "menu,noinsert,menuone,noselect,preview"
o.mouse = ""

g.lazyvim_picker = "telescope"
g.autoformat = false

vim.filetype.add({
  extension = {
    ["http"] = "http",
  },
})

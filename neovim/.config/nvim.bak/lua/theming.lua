local v = vim
local o = v.o
local c = v.cmd
local a = v.api
local h = a.nvim_set_hl

o.updatetime = 75
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
o.showbreak = "↳ "
o.showmode = false
o.foldmethod = "expr"
o.foldexpr = "nvim_treesitter#foldexpr()"
o.foldlevelstart = 6
o.foldcolumn = "3"
o.signcolumn = "yes:4"
o.numberwidth = 5
o.completeopt = "menu,noinsert,menuone,noselect,preview"
v.opt.shortmess:append("c")
c("colorscheme moonfly")
c("syntax sync fromstart")

c("highlight SpellBad guisp=DarkRed gui=undercurl cterm=undercurl")

-- Default search formatting
local searchBgInactive = "#ffff54"
local searchBgActive = "#fe9a4a"
local searchFg = "#000000"
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
	foreground = "#666666",
})

-- Default Cursor Line
h(0, "CursorLineNr", {
	foreground = "#00ffff",
	bold = true,
})
h(0, "CursorLineFold", {
	background = "#666666",
})
h(0, "CursorLineSign", {
	background = "#343434",
})

-- Mode specific MsgArea, CursorLineNr and LineNr formatting
a.nvim_create_autocmd("ModeChanged", {
	callback = function()
		local mode = v.api.nvim_get_mode().mode
		local colorsForCursorLine = {
			["i"] = "#00ff00",
			["n"] = "#00ffff",
			["c"] = "#e0af68",
			["v"] = "#c678dd",
			["V"] = "#c678dd",
			[""] = "#c678dd",
		}

		h(0, "CursorLineNr", {
			foreground = colorsForCursorLine[mode] or "#666666",
			bold = true,
		})

		if mode == "c" then
			h(0, "MsgArea", {
				foreground = colorsForCursorLine[mode],
			})
			h(0, "LineNr", {
				foreground = colorsForCursorLine[mode],
			})
		else
			h(0, "MsgArea", {
				foreground = "#cccccc",
			})
			h(0, "LineNr", {
				foreground = "#666666",
			})
		end
	end,
})

v.diagnostic.config({
	float = { border = "single" },
})

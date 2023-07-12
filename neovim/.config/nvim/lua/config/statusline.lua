local icons = require("icons")
local navic = require("nvim-navic")
navic.setup({ highlight = true, depth_limit = 3, depth_limit_indicator = "..." })

-- Custom filename handler for bottom status bar
local custom_fname = require("lualine.components.filename"):extend()
local highlight = require("lualine.highlight")
local default_status_colors = { saved = "#228B22", modified = "#C70039" }

function custom_fname:init(options)
	custom_fname.super.init(self, options)
	self.status_colors = {
		saved = highlight.create_component_highlight_group({
			bg = default_status_colors.saved,
		}, "filename_status_saved", self.options),
		modified = highlight.create_component_highlight_group({
			bg = default_status_colors.modified,
		}, "filename_status_modified", self.options),
	}
	if self.options.color == nil then
		self.options.color = ""
	end
end

function custom_fname:update_status()
	local data = custom_fname.super.update_status(self)
	data = highlight.component_format_highlight(
		vim.bo.modified and self.status_colors.modified or self.status_colors.saved
	) .. data
	return data
end

-- Git module for getting git info per file and project as I like
local M = {}

M.timer = vim.loop.new_timer()

M.statusValues = { fileCount = 0, addCount = 0, delCount = 0, untracked = 0 }

local isInRepo = function()
	local handle = io.popen([[
    if GPATH=`git rev-parse --show-toplevel --quiet 2>/dev/null`; then
      echo "repo: $GPATH"
    fi
  ]])
	local repo = handle:read("*a")
	handle:close()
	return string.len(repo) > 0
end

local handleIfInRepoOrNot = function(func)
	if isInRepo() then
		return func()
	else
		return "N/A"
	end
end

M.gitStatus = {
	added = function()
		return handleIfInRepoOrNot(function()
			return icons.kind.File .. " " .. M.statusValues.fileCount
		end)
	end,
	modified = function()
		return handleIfInRepoOrNot(function()
			return icons.git.Add .. M.statusValues.addCount
		end)
	end,
	removed = function()
		return handleIfInRepoOrNot(function()
			return icons.git.Remove .. M.statusValues.delCount
		end)
	end,
	untracked = function()
		return handleIfInRepoOrNot(function()
			return icons.kind.Module .. " " .. M.statusValues.untracked
		end)
	end,
}

M.gitStatusForRepo = function()
	if not isInRepo() then
		M.statusValues = {
			fileCount = "N/A",
			addCount = "N/A",
			delCount = "N/A",
			untracked = "N/A",
		}

		return
	end

	local handle = io.popen("git diff --shortstat")
	local statusText = handle:read("*a")

	handle = io.popen("git ls-files --others --exclude-standard | wc -l")
	local untracked = handle:read("*a")

	local fileCount = string.match(statusText, "(%d+) file") or "0"
	local addCount = string.match(statusText, "(%d+) inser") or "0"
	local delCount = string.match(statusText, "(%d+) del") or "0"
	untracked = string.gsub(untracked, "%s+", "")

	M.statusValues = {
		fileCount = fileCount,
		addCount = addCount,
		delCount = delCount,
		untracked = untracked,
	}
	handle:close()
end

function M.setup()
	local gitSignsForFile = function()
		local gitsigns = vim.b.gitsigns_status_dict
		if gitsigns then
			return {
				added = gitsigns.added,
				modified = gitsigns.changed,
				removed = gitsigns.removed,
			}
		end
	end

	require("lualine").setup({
		options = {
			icons_enabled = true,
			theme = "material",
			component_separators = { left = "", right = "" },
			section_separators = { left = "", right = "" },
			disabled_filetypes = { statusline = {}, winbar = {} },
			ignore_focus = {},
			always_divide_middle = true,
			globalstatus = true,
			refresh = { statusline = 1000, tabline = 1000, winbar = 1000 },
		},
		sections = {
			lualine_a = { { "mode", separator = { left = "" } } },
			lualine_b = {
				{ "b:gitsigns_head", icon = "", color = { fg = "#77ff77" } },
				{
					M.gitStatus.untracked,
					color = { fg = "#74b2ff" },
					separator = "",
				},
				{ M.gitStatus.added, color = { fg = "#e3c78a" }, separator = "" },
				{ M.gitStatus.modified, color = { fg = "#36c692" }, separator = "" },
				{ M.gitStatus.removed, color = { fg = "#ff5454" } },
				{
					"diagnostics",
					always_visible = true,
					update_in_insert = true,
					sources = {
						"nvim_lsp",
						"nvim_diagnostic",
						"nvim_workspace_diagnostic",
					},
				},
			},
			lualine_c = { custom_fname },
			lualine_x = { "filetype" },
			lualine_y = { "progress" },
			lualine_z = {
				{ "location", separator = { right = "" }, left_padding = 2 },
			},
		},
		tabline = {
			lualine_z = { { "filename", path = 1 } },
		},
		winbar = {
      -- Starting with B due to nicer theming on B and C sections
			lualine_b = { "diagnostics", { "diff", source = gitSignsForFile } },
			lualine_c = {
				"navic",
				color_correction = nil,
				navic_opts = nil,
			},
		},
		inactive_winbar = {},
		extensions = { "nvim-tree", "quickfix", "nvim-dap-ui" },
	})
end

M.timer:start(10000, 10000, function()
	M.gitStatusForRepo()
end)

return M

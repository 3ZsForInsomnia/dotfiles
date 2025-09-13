local v = vim
local icons = require("lazyvim.config").icons

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
  data = highlight.component_format_highlight(v.bo.modified and self.status_colors.modified or self.status_colors.saved)
    .. data
  return data
end

local gitSignsForFile = function()
  local gitsigns = v.b.gitsigns_status_dict
  if gitsigns then
    return {
      added = gitsigns.added,
      modified = gitsigns.changed,
      removed = gitsigns.removed,
    }
  end
end

-- Git module for getting git info per file and project as I like
local M = {}

M.handle = nil
M.timer = v.loop.new_timer()
M.statusValues = { fileCount = 0, addCount = 0, delCount = 0, untracked = 0 }
M.isInsideARepo = nil

M.isInRepo = function()
  if M.isInsideARepo ~= nil then
    return M.isInsideARepo
  end

  M.handle = io.popen([[
    if GPATH=`git rev-parse --show-toplevel --quiet 2>/dev/null`; then
      echo "repo: $GPATH"
    fi
  ]])

  local raw = M.handle:read("*a")
  local repo = string.len(raw) > 0

  M.isInsideARepo = repo

  return repo
end

M.gitStatus = {
  filesTouched = function()
    return icons.kinds.File .. " " .. M.statusValues.fileCount
  end,
  modified = function()
    return icons.git.added .. M.statusValues.addCount
  end,
  removed = function()
    return icons.git.removed .. M.statusValues.delCount
  end,
  untracked = function()
    return icons.kind.Module .. " " .. M.statusValues.untracked
  end,
}

M.gitStatusForRepo = function()
  if not M.isInRepo() then
    M.statusValues = {
      fileCount = "N/A",
      addCount = "N/A",
      delCount = "N/A",
      untracked = "N/A",
    }
    return
  end

  vim.system({
    "sh",
    "-c",
    [[
      git diff --shortstat;
      echo "SEPARATOR";
      git ls-files --others --exclude-standard | wc -l
    ]],
  }, {}, function(result)
    if result.code == 0 then
      local output = result.stdout
      local parts = v.split(output, "SEPARATOR")
      local statusText = parts[1] or ""
      local untracked = v.trim(parts[2] or "0")

      local fileCount = string.match(statusText, "(%d+) file") or "0"
      local addCount = string.match(statusText, "(%d+) inser") or "0"
      local delCount = string.match(statusText, "(%d+) del") or "0"

      M.statusValues = {
        fileCount = fileCount,
        addCount = addCount,
        delCount = delCount,
        untracked = untracked,
      }
    else
      -- Fallback on error
      M.statusValues = {
        fileCount = "ERR",
        addCount = "ERR",
        delCount = "ERR",
        untracked = "ERR",
      }
    end
  end)
end

return {
  {
    "SmiteshP/nvim-navic",
    event = "VeryLazy",
    config = function()
      require("nvim-navic").setup({
        highlight = true,
        depth_limit = 3,
        depth_limit_indicator = "...",
        lazy_update_context = true,
      })
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    config = function()
      vim.defer_fn(function()
        M.isInsideARepo = M.isInRepo()
        if not M.isInsideARepo then
          return
        end

        M.gitStatusForRepo()
        M.timer:start(10000, 10000, function()
          M.gitStatusForRepo()
        end)
      end, 5000)

      require("lualine").setup({
        options = {
          theme = "catppuccin",
          icons_enabled = true,
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          disabled_filetypes = { statusline = {}, winbar = {} },
          ignore_focus = {},
          always_divide_middle = true,
          globalstatus = true,
          refresh = {
            statusline = 100,
            tabline = 1000,
            winbar = 250,
            events = {
              "WinEnter",
              "BufEnter",
              "BufWritePost",
              "SessionLoadPost",
              "FileChangedShellPost",
              "VimResized",
              "Filetype",
              "CursorHold",
              "CursorHoldI",
              -- "CursorMoved",
              -- "CursorMovedI",
              "ModeChanged",
            },
          },
        },
        sections = {
          lualine_a = { { "mode", separator = { left = "" } } },
          lualine_b = {
            { "b:gitsigns_head", icon = "", color = { fg = "#77ff77" } },
            {
              M.gitStatus.untracked,
              cond = function()
                return M.isInRepo()
              end,
              color = { fg = "#74b2ff" },
              separator = "",
            },
            {
              M.gitStatus.filesTouched,
              cond = function()
                return M.isInRepo()
              end,
              color = { fg = "#e3c78a" },
              separator = "",
            },
            {
              M.gitStatus.modified,
              cond = function()
                return M.isInRepo()
              end,
              color = { fg = "#36c692" },
              separator = "",
            },
            {
              M.gitStatus.removed,
              cond = function()
                return M.isInRepo()
              end,
              color = { fg = "#ff5454" },
            },
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
          lualine_c = {
            { "filename", new_file_status = true, path = 1 },
          },
          lualine_x = {
            require("token-count.integrations.lualine").current_buffer,
          },
          lualine_y = { "progress" },
          lualine_z = {
            { "location", separator = { right = "" }, left_padding = 2 },
          },
        },
        winbar = {
          -- Starting with B due to nicer theming on B and C sections
          lualine_b = { "diagnostics", { "diff", source = gitSignsForFile } },
          lualine_c = {
            "navic",
            color_correction = nil,
            navic_opts = nil,
          },
          lualine_z = {
            {
              "searchcount",
              maxcount = 999,
              timeout = 500,
            },
          },
        },
        inactive_winbar = {},
        extensions = { "neo-tree", "quickfix", "nvim-dap-ui" },
      })
    end,
  },
}

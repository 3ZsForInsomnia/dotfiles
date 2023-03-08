local icons = require('icons')

local M = {}

M.timer = vim.loop.new_timer()

M.statusValues = {
  fileCount = 0,
  addCount = 0,
  delCount = 0,
  untracked = 0,
}

M.gitStatus = {
  added = function() return icons.kind.File .. M.statusValues.fileCount end,
  modified = function() return icons.git.Add .. M.statusValues.addCount end,
  removed = function() return icons.git.Remove .. M.statusValues.delCount end,
  untracked = function() return icons.kind.Module .. ' ' .. M.statusValues.untracked end,
}

M.gitStatusForRepo = function()
  local handle = io.popen('git diff --shortstat')
  local statusText = handle:read("*a")
  handle:close()

  handle = io.popen('git ls-files --others --exclude-standard | wc -l')
  local untracked = handle:read("*a")

  local fileCount = string.match(statusText, '(%d+) file') or "0"
  local addCount = string.match(statusText, '(%d+) inser') or "0"
  local delCount = string.match(statusText, '(%d+) del') or "0"
  untracked = string.gsub(untracked, "%s+", "")

  M.statusValues = {
    fileCount = fileCount,
    addCount = addCount,
    delCount = delCount,
    untracked = untracked,
  }
end

function M.setup()
  local gitSignsForFile = function()
    local gitsigns = vim.b.gitsigns_status_dict
    if gitsigns then
      return {
        added = gitsigns.added,
        modified = gitsigns.changed,
        removed = gitsigns.removed
      }
    end
  end

  require('lualine').setup {
    options = {
      icons_enabled = true,
      theme = 'material',
      component_separators = { left = '', right = '' },
      section_separators = { left = '', right = '' },
      disabled_filetypes = {
        statusline = {},
        winbar = {},
      },
      ignore_focus = {},
      always_divide_middle = true,
      globalstatus = true,
      refresh = {
        statusline = 1000,
        tabline = 1000,
        winbar = 1000,
      }
    },
    sections = {
      lualine_a = { { 'mode', separator = { left = '' } } },
      lualine_b = {
        { 'b:gitsigns_head', icon = '', color = { fg = "#77ff77" } },
        { M.gitStatus.untracked, color = { fg = "#74b2ff" }, separator = '' },
        { M.gitStatus.added, color = { fg = "#e3c78a" }, separator = '' },
        { M.gitStatus.modified, color = { fg = "#36c692" }, separator = '' },
        { M.gitStatus.removed, color = { fg = "#ff5454" } },
        {
          'diagnostics',
          always_visible = true,
          update_in_insert = true,
          sources = { 'nvim_lsp', 'nvim_diagnostic', 'nvim_workspace_diagnostic', }
        },
      },
      lualine_c = { 'filename' },
      lualine_x = { 'filetype' },
      lualine_y = { 'progress' },
      lualine_z = { { 'location', separator = { right = '' }, left_padding = 2 } },
    },
    tabline = {
      lualine_a = {
        { 'buffers', show_filename_only = false, hide_filename_extension = true, mode = 2, max_length = 300 }
      },
    },
    winbar = {
      lualine_a = { { 'filename', path = 1 } },
      lualine_b = { { 'diff', source = gitSignsForFile } },
      lualine_c = { 'diagnostics' },
    },
    inactive_winbar = {},
    extensions = { 'nvim-tree', 'quickfix', 'nvim-dap-ui' }
  }
end

M.timer:start(2000, 2000, function() M.gitStatusForRepo() end)

return M

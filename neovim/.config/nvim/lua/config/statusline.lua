local icons = require('icons')

local M = {}

function M.setup()
  local gitStatusForRepo = function()
    local handle = io.popen('git diff --shortstat')
    local statusText = handle:read("*a")
    handle:close()

    local iter = string.gmatch(statusText, '%d+')
    local results = {}
    local count = 1
    for i in iter do
      results[count] = i
      count = count + 1
    end

    return {
      added = function() return icons.kind.File .. tostring(results[1] or 0) end,
      modified = function() return icons.git.Add .. tostring(results[2] or 0) end,
      removed = function() return icons.git.Remove .. tostring(results[3] or 0) end,
    }
  end

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
        { gitStatusForRepo().added, color = { fg = "#e3c78a" }, separator = '' },
        { gitStatusForRepo().modified, color = { fg = "#36c692" }, separator = '' },
        { gitStatusForRepo().removed, color = { fg = "#ff5454" } },
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

M.setup()

return M

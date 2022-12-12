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
      { 'diagnostics',
        always_visible = true,
        update_in_insert = true,
        sources = { 'nvim_lsp', 'nvim_diagnostic', 'nvim_workspace_diagnostic', }
      },
      'branch',
    },
    lualine_c = {
      'filename',
    },
    lualine_x = { 'filetype' },
    lualine_y = { 'progress' },
    lualine_z = {
      { 'location', separator = { right = '' }, left_padding = 2 },
    }
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { 'filename' },
    lualine_x = { 'location' },
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {
    lualine_a = {
      { 'buffers', show_filename_only = false, hide_filename_extension = true, mode = 2, max_length = 300 }
    },
  },
  winbar = {
    lualine_a = {
      { 'filename', path = 1 }
    },
    lualine_b = { 'diff' },
    lualine_c = { 'diagnostics' },
  },
  inactive_winbar = {},
  extensions = { 'chadtree', 'quickfix', 'nvim-dap-ui' }
}

return {
  {
    "catppuccin/nvim",
    lazy = true,
    name = "catppuccin",
    opts = {
      flavour = "mocha", -- latte, frappe, macchiato, mocha
      transparent_background = false, -- disables setting the background color.
      show_end_of_buffer = true, -- shows the '~' characters after the end of buffers
      term_colors = false, -- sets terminal colors (e.g. `g:terminal_color_0`)
      dim_inactive = {
        enabled = false, -- dims the background color of inactive window
        shade = "dark",
        percentage = 0.15, -- percentage of the shade to apply to the inactive window
      },
      no_italic = false, -- Force no italic
      no_bold = false, -- Force no bold
      no_underline = false, -- Force no underline
      styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
        comments = { "italic" }, -- Change the style of comments
        conditionals = { "italic" },
        loops = {},
        functions = {},
        keywords = {},
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = {},
        operators = {},
        -- miscs = {}, -- Uncomment to turn off hard-coded styles
      },
      color_overrides = {},
      custom_highlights = {},
      default_integrations = true,
      integrations = {
        aerial = true,
        alpha = true,
        cmp = true,
        dap = true,
        dap_ui = true,
        dashboard = true,
        diffview = true,
        flash = false,
        gitsigns = true,
        headlines = true,
        illuminate = true,
        indent_blankline = { enabled = true },
        leap = true,
        lsp_trouble = true,
        mason = true,
        markdown = true,
        mini = true,
        native_lsp = {
          enabled = true,
          underlines = {
            errors = { "undercurl" },
            hints = { "undercurl" },
            warnings = { "undercurl" },
            information = { "undercurl" },
          },
        },
        navic = { enabled = true, custom_bg = "lualine" },
        neotest = true,
        neotree = true,
        noice = true,
        notify = true,
        octo = true,
        rainbow_delimiters = true,
        semantic_tokens = true,
        telescope = true,
        treesitter = true,
        treesitter_context = true,
        which_key = true,
      },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
  "onsails/lspkind-nvim",
  "HiPhish/rainbow-delimiters.nvim",
  "goldos24/rainbow-variables-nvim",
  {
    "m-demare/hlargs.nvim",
    opts = {
      paint_catch_blocks = {
        declarations = true,
        usages = true,
      },
      color = "#ef9062",
      use_colorpalette = true,
      colorpalette = {
        { fg = "#ef9062" },
        { fg = "#3AC6BE" },
        { fg = "#35D27F" },
        { fg = "#EB75D6" },
        { fg = "#E5D180" },
        { fg = "#8997F5" },
        { fg = "#D49DA5" },
        { fg = "#7FEC35" },
        { fg = "#F6B223" },
        { fg = "#F67C1B" },
        { fg = "#DE9A4E" },
        { fg = "#BBEA87" },
        { fg = "#EEF06D" },
        { fg = "#8FB272" },
      },
      disable = function(_, bufnr)
        if vim.b.semantic_tokens then
          return true
        end
        local clients = vim.lsp.get_clients({ bufnr = bufnr })
        for _, c in pairs(clients) do
          local caps = c.server_capabilities
          if c.name ~= "null-ls" and caps.semanticTokensProvider and caps.semanticTokensProvider.full then
            vim.b.semantic_tokens = true
            return vim.b.semantic_tokens
          end
        end
      end,
    },
  },
}

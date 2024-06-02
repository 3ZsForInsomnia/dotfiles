return {
  { "bluz71/vim-moonfly-colors", name = "moonfly", lazy = false, priority = 1000 },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "moonfly",
    },
  },
  { "onsails/lspkind-nvim" },
  { "HiPhish/rainbow-delimiters.nvim" },
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

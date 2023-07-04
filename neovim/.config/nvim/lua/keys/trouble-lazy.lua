local wk = require("which-key")
local trouble = require("trouble.providers.telescope")

wk.register({
  ['<leader>'] = {
    f = {
      name = 'Telescope Find',
      l = {
        name = "Telescope LSP",
        [''] = { trouble.open_with_trouble, "Show diagnostics" },
        d = { trouble.open_with_trouble, "Show diagnostics" },
      }
    }
  }
})

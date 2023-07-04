require("config.dap.javascript").setup()
require("nvim-dap-virtual-text").setup()
require("dapui").setup()
require('dap-python').setup('~/miniconda3/bin/python')
require('telescope').load_extension('dap')

require("cmp").setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
  sources = {
    { name = "dap" },
  },
})

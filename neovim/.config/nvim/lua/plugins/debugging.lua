return {
  { "theHamsta/nvim-dap-virtual-text",   event = "VeryLazy" },
  { "rcarriga/nvim-dap-ui",              event = "VeryLazy" },
  { "mfussenegger/nvim-dap-python",      event = "VeryLazy" },
  { "nvim-telescope/telescope-dap.nvim", event = "VeryLazy" },
  { "mxsdev/nvim-dap-vscode-js",         event = "VeryLazy" },
  { "rcarriga/cmp-dap",                  event = "VeryLazy" },
  {
    "microsoft/vscode-js-debug",
    run = "npm install --legacy-peer-deps && npm run compile",
    event = "VeryLazy",
  },
  {
    "mfussenegger/nvim-dap",
    event = "VeryLazy",
    dependencies = {
      "theHamsta/nvim-dap-virtual-text",
      "rcarriga/nvim-dap-ui",
      "mfussenegger/nvim-dap-python",
      "nvim-telescope/telescope-dap.nvim",
      "mxsdev/nvim-dap-vscode-js",
      "rcarriga/cmp-dap",
    }
  },
}

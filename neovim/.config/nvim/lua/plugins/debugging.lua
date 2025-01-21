-- local cmd = require("helpers").k_cmd
-- local d = "<leader>d"
-- local dc = function(command)
--   return "DBUI " .. command
-- end

return {
  { "theHamsta/nvim-dap-virtual-text", event = "VeryLazy" },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    event = "VeryLazy",
    opts = {
      controls = {
        element = "repl",
        enabled = true,
        icons = {
          disconnect = "",
          pause = "",
          play = "",
          run_last = "",
          step_back = "",
          step_into = "",
          step_out = "",
          step_over = "",
          terminate = "",
        },
      },
      element_mappings = {},
      expand_lines = true,
      floating = {
        border = "single",
        mappings = {
          close = { "q", "<Esc>" },
        },
      },
      force_buffers = true,
      icons = {
        collapsed = "",
        current_frame = "",
        expanded = "",
      },
      layouts = {
        {
          elements = {
            {
              id = "scopes",
              size = 0.25,
            },
            {
              id = "breakpoints",
              size = 0.25,
            },
            {
              id = "stacks",
              size = 0.25,
            },
            {
              id = "watches",
              size = 0.25,
            },
          },
          position = "left",
          size = 40,
        },
        {
          elements = {
            {
              id = "repl",
              size = 0.5,
            },
            {
              id = "console",
              size = 0.5,
            },
          },
          position = "bottom",
          size = 10,
        },
      },
      mappings = {
        edit = "e",
        expand = { "<CR>", "<2-LeftMouse>" },
        open = "o",
        remove = "d",
        repl = "r",
        toggle = "t",
      },
      render = {
        indent = 1,
        max_value_lines = 100,
      },
    },
  },
  { "mfussenegger/nvim-dap-python", event = "VeryLazy" },
  { "nvim-telescope/telescope-dap.nvim", event = "VeryLazy" },
  { "mxsdev/nvim-dap-vscode-js", event = "VeryLazy" },
  { "leoluz/nvim-dap-go", event = "VeryLazy" },
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
      -- "rcarriga/cmp-dap",
      "leoluz/nvim-dap-go",
    },
  },
}

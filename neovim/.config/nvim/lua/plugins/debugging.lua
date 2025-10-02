local v = vim.fn.sign_define

return {
  {
    "mfussenegger/nvim-dap",
    cmd = {
      "DapNew",
      "DapContinue",
      "DapStepInto",
      "DapStepOver",
      "DapStepOut",
      "DapStepBack",
      "DapPause",
      "DapToggleBreakpoint",
      "DapSetBreakpoint",
      "DapClearBreakpoints",
      "DapRestartFrame",
      "DapTerminate",
      "DapRunToCursor",
    },
    dependencies = {
      {
        "rcarriga/nvim-dap-ui",
        dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
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
              terminate = "",
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
      "theHamsta/nvim-dap-virtual-text",
      "mxsdev/nvim-dap-vscode-js",
      {
        "microsoft/vscode-js-debug",
        run = "npm install --legacy-peer-deps && npm run compile",
      },
    },
    config = function()
      v("DapBreakpoint", { text = "🟥", texthl = "DiagnosticSignError", priority = 15 })
      v("DapBreakpointCondition", { text = "🟦", texthl = "DiagnosticSignWarn", priority = 15 })
      v("DapBreakpointRejected", { text = "", texthl = "DiagnosticSignInfo", priority = 15 })
      v("DapLogPoint", { text = "🔷", texthl = "DiagnosticSignHint", priority = 15 })
      v("DapStopped", { text = "⭐️", texthl = "DiagnosticSignInfo", priority = 15 })
    end,
  },
}

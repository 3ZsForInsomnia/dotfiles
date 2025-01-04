local cmd = require("helpers").k_cmd
local d = "<leader>d"
local dc = function(command)
  return "DBUI " .. command
end

return {
  { "theHamsta/nvim-dap-virtual-text", event = "VeryLazy" },
  { "rcarriga/nvim-dap-ui", dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" }, event = "VeryLazy" },
  { "mfussenegger/nvim-dap-python", event = "VeryLazy" },
  { "nvim-telescope/telescope-dap.nvim", event = "VeryLazy" },
  { "mxsdev/nvim-dap-vscode-js", event = "VeryLazy" },
  { "leoluz/nvim-dap-go", event = "VeryLazy" },
  -- { "rcarriga/cmp-dap", event = "VeryLazy" },
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

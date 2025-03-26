local k_cmd = require("helpers").k_cmd

local copilot = "<leader>a"

return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    event = "VeryLazy",
    branch = "canary",
    dependencies = {
      {
        "zbirenbaum/copilot.lua",
        opts = {
          suggestion = { enabled = false },
          panel = { enabled = false },
        },
      },
      { "nvim-lua/plenary.nvim" },
    },
    opts = {
      model = "claude-3.7-sonnet-thought",
    },
    keys = {
      --
      -- Utils
      --
      k_cmd({
        key = copilot .. "m",
        action = "CopilotChatModels",
        desc = "Select Model",
      }),

      --
      -- Chat commands
      --
      k_cmd({
        key = copilot .. "c",
        action = "CopilotChat",
        desc = "Copilot Chat",
      }),
      k_cmd({
        key = copilot .. "C",
        action = "CopilotChatClose",
        desc = "Close Chat",
      }),
      k_cmd({
        key = copilot .. "S",
        action = "CopilotChatSave",
        desc = "Save Chat",
      }),

      --
      -- Prompts
      --
      k_cmd({
        key = copilot .. "b",
        action = "CopilotChatBetterNamings",
        desc = "Copilot Better Namings",
      }),
      k_cmd({
        key = copilot .. "d",
        action = "CopilotChatDocs",
        desc = "Copilot Docs",
      }),
      k_cmd({
        key = copilot .. "e",
        action = "CopilotChatExplain",
        desc = "Copilot Explain",
      }),
      k_cmd({
        key = copilot .. "f",
        action = "CopilotChatFix",
        desc = "Copilot Fix",
      }),
      k_cmd({
        key = copilot .. "g",
        action = "CopilotChatCommit",
        desc = "Copilot Git Commit",
      }),
      k_cmd({
        key = copilot .. "l",
        action = "CopilotChatFixDiagnostic",
        desc = "Copilot Fix Diagnostic",
      }),
      k_cmd({
        key = copilot .. "o",
        action = "CopilotChatOptimize",
        desc = "Copilot Optimize",
      }),
      k_cmd({
        key = copilot .. "t",
        action = "CopilotChatTests",
        desc = "Copilot Tests",
      }),
      k_cmd({
        key = copilot .. "v",
        action = "CopilotChatReview",
        desc = "Copilot Review",
      }),

      --
      -- Visual Mode Prompts
      --
      k_cmd({
        key = copilot .. "d",
        action = "CopilotChatDocs",
        desc = "Copilot Docs",
        mode = "v",
      }),
      k_cmd({
        key = copilot .. "e",
        action = "CopilotChatExplain",
        desc = "Copilot Explain",
        mode = "v",
      }),
      k_cmd({
        key = copilot .. "o",
        action = "CopilotChatOptimize",
        mode = "v",
        desc = "Copilot Optimize",
      }),
      k_cmd({
        key = copilot .. "t",
        action = "CopilotChatTests",
        desc = "Copilot Tests",
        mode = "v",
      }),
      k_cmd({
        key = copilot .. "v",
        action = "CopilotChatReview",
        mode = "v",
        desc = "Copilot Review",
      }),
    },
  },
}

local k_cmd = require("helpers").k_cmd

local ai = "<leader>a"
local chatgpt = ai .. "g"
local copilot = ai .. "c"

return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    event = "VeryLazy",
    branch = "canary",
    dependencies = {
      { "zbirenbaum/copilot.lua" },
      { "nvim-lua/plenary.nvim" },
    },
    opts = {},
    keys = {
      k_cmd({
        key = copilot .. "c",
        action = "CopilotChat",
        desc = "Copilot Chat",
      }),
      k_cmd({
        key = copilot .. "v",
        action = "CopilotChatReview",
        desc = "Copilot Review",
      }),
      -- k_cmd({
      --   key = copilot .. "rv",
      --   action = "CopilotChatReview",
      --   desc = "Copilot Review",
      --   mode = "v",
      -- }),
      k_cmd({
        key = copilot .. "r",
        action = "CopilotChatRefactor",
        desc = "Copilot Refactor",
      }),
      -- k_cmd({
      --   key = copilot .. "rf",
      --   action = "CopilotChatRefactor",
      --   desc = "Copilot Refactor",
      --   mode = "v",
      -- }),
      k_cmd({
        key = copilot .. "e",
        action = "CopilotChatExplain",
        desc = "Copilot Explain",
      }),
      -- k_cmd({
      --   key = copilot .. "e",
      --   action = "CopilotChatExplain",
      --   desc = "Copilot Explain",
      --   mode = "v",
      -- }),
      k_cmd({
        key = copilot .. "b",
        action = "CopilotChatBetterNamings",
        desc = "Copilot Better Namings",
      }),
      k_cmd({
        key = copilot .. "t",
        action = "CopilotChatTests",
        desc = "Copilot Tests",
      }),
      -- k_cmd({
      --   key = copilot .. "t",
      --   action = "CopilotChatTests",
      --   desc = "Copilot Tests",
      --   mode = "v",
      -- }),
      k_cmd({
        key = copilot .. "i",
        action = "CopilotChatInline",
        desc = "Copilot Inline Chat",
      }),
      k_cmd({
        key = copilot .. "g",
        action = "CopilotChatCommit",
        desc = "Copilot Git Commit",
      }),
      k_cmd({
        key = copilot .. "f",
        action = "CopilotChatFixDiagnostic",
        desc = "Copilot Fix Diagnostic",
      }),
      k_cmd({
        key = copilot .. "d",
        action = "CopilotChatDocs",
        desc = "Copilot Docs",
      }),
      -- k_cmd({
      --   key = copilot .. "d",
      --   action = "CopilotChatDocs",
      --   desc = "Copilot Docs",
      --   mode = "v",
      -- }),
    },
  },
  {
    "jackMort/ChatGPT.nvim",
    event = "VeryLazy",
    opts = {
      openai_params = {
        model = "gpt-4o-2024-05-13",
      },
    },
    config = true,
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "folke/trouble.nvim",
      "nvim-telescope/telescope.nvim",
    },
    keys = {
      k_cmd({
        key = chatgpt .. "c",
        action = "ChatGPT",
        desc = "Chat with GPT",
      }),
      -- k_cmd({
      --   key = chatgpt .. "r",
      --   action = "ChatGPTRun",
      --   desc = "ChatGPT run actions",
      -- }),
      k_cmd({
        key = chatgpt .. "rx",
        action = "ChatGPTRun explain_code",
        desc = "ChatGPT explain code",
      }),
      k_cmd({
        key = chatgpt .. "rs",
        action = "ChatGPTRun summarize",
        desc = "ChatGPTRun summarize",
      }),
      k_cmd({
        key = chatgpt .. "ra",
        action = "ChatGPTRun code_readability_analysis",
        desc = "ChatGPTRun code readability analysis",
      }),
      k_cmd({
        key = chatgpt .. "ro",
        action = "ChatGPTRun optimize_code",
        desc = "ChatGPTRun code optimization",
      }),
      k_cmd({
        key = chatgpt .. "rd",
        action = "ChatGPTRun docstring",
        desc = "ChatGPTRun document",
      }),
      k_cmd({
        key = chatgpt .. "e",
        action = "ChatGPTEditWithInstructions",
        desc = "ChatGPT edit with instructions",
      }),
    },
  },
}

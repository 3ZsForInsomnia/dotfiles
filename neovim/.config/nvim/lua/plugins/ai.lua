local v = vim

local k_cmd = require("helpers").k_cmd
local k = require("helpers").k

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
      window = {
        width = 0.5,
      },
    },
    config = function(_, opts)
      -- This is mostly an example
      local vectorcode_ctx = require("vectorcode.integrations.copilotchat").make_context_provider({
        -- prompt_header = "Here are relevant files from the repository:", -- Customize header text
        -- prompt_footer = "\nConsider this context when answering:", -- Customize footer text
        skip_empty = true, -- Skip adding context when no files are retrieved
      })

      opts.contexts = {
        vectorcode = vectorcode_ctx,
      }
      opts.sticky = {
        "#vectorcode",
      }

      v.api.nvim_create_autocmd("BufEnter", {
        pattern = "copilot-chat",
        callback = function()
          v.opt_local.conceallevel = 0
          v.opt_local.number = true
          v.opt_local.relativenumber = true
          v.opt_local.signcolumn = "no"
          v.opt_local.foldcolumn = "0"
          v.opt_local.fillchars = ""
        end,
      })

      require("CopilotChat").setup(opts)
    end,
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
        key = copilot .. "s",
        action = "CopilotChatStop",
        desc = "Stop Chat",
      }),
      k({
        key = copilot .. "S",
        action = ":CopilotChatSave ",
        desc = "Save Chat",
      }),
      k({
        key = copilot .. "l",
        action = "CopilotChatLoad",
        desc = "Load Chat",
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
  {
    "Davidyz/VectorCode",
    version = "*",
    build = "uv tool upgrade vectorcode",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "VectorCode",
  },
}

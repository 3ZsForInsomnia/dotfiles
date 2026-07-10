local k_cmd = require("helpers").k_cmd
local k = require("helpers").k
local cc_models = require("config.codecompanion.models")

local a = "<leader>a"

return {
  {
    "Davidyz/VectorCode",
    version = "*",
    build = "uv tool upgrade vectorcode",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "VectorCode",
    opts = {
      async_backend = "lsp",
      on_setup = { lsp = true },
    },
  },
  {
    "3ZsForInsomnia/token-count.nvim",
    event = "VeryLazy",
    config = true,
    opts = {
      model = "claude-4.6-sonnet",
      copilot_host = false,
    },
  },
  {
    "olimorris/codecompanion.nvim",
    cmd = {
      "CodeCompanion",
      "CodeCompanionChat",
      "CodeCompanionActions",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "ravitemer/codecompanion-history.nvim",
      {
        "Davidyz/codecompanion-dap.nvim",
        dependencies = {
          "mfussenegger/nvim-dap",
        },
      },
      {
        "3ZsForInsomnia/vs-code-companion",
        -- dir = "~/src/vs-code-companion",
        cmd = "VsccImport",
      },
      {
        -- "3ZsForInsomnia/code-companion-picker",
        dir = "~/src/code-companion-picker",
        cmd = "CodeCompanionPrompts",
      },
    },
    opts = {
      rules = {
        personal = {
          files = {
            os.getenv("HOME") .. "/.agent/AGENTS.md",
          },
        },
        eslint = require("config.codecompanion.rules").conditional_rule(
          "ESLint config",
          "**/*.{ts,tsx,js,jsx}",
          { "eslint.config.js" }
        ),
        golangci_lint = require("config.codecompanion.rules").conditional_rule(
          "Go linter configs",
          "**/*.go",
          { ".golangci.ci.yaml" }
        ),
        opts = {
          chat = {
            autoload = { "default", "personal" },
            enabled = true,
          },
        },
      },
      opts = {
        log_level = "DEBUG",
      },
      display = {
        chat = {
          show_token_count = false,
          start_in_insert_mode = true,
          window = {
            opts = {
              cursorline = true,
              foldcolumn = "3",
              numberwidth = 3,
              spell = true,
            },
          },
          icons = {
            chat_fold = " ",
          },
          fold_reasoning = true,
          show_reasoning = true,
        },
      },
      prompt_library = require("config.codecompanion.prompts"),
      extensions = require("config.codecompanion.extensions"),
      interactions = require("config.codecompanion.interactions"),
      adapters = {
        http = {
          opts = {
            show_model_choices = true,
          },
          -- Local model. All tuning lives in config.codecompanion.models so the
          -- model can be swapped in one place. Shared with minuet (text
          -- completion) and CodeCompanion's inline + background strategies.
          [cc_models.local_adapter] = function()
            return require("codecompanion.adapters").extend("ollama", {
              name = cc_models.local_adapter,
              schema = {
                model = { default = cc_models.local_model },
                num_ctx = { default = cc_models.local_num_ctx },
                temperature = { default = cc_models.local_temperature },
                keep_alive = { default = cc_models.local_keep_alive },
                think = { default = cc_models.local_think },
              },
            })
          end,
        },
        acp = {
          claude_code = function()
            return require("codecompanion.adapters").extend("claude_code", {
              env = {
                CLAUDE_CODE_OAUTH_TOKEN = "CLAUDE_CODE_TOKEN",
              },
              defaults = {
                mcpServers = "inherit_from_config",
                session_config_options = {
                  model = cc_models.remote_thinking_model,
                  thought_level = cc_models.remote_thought_level,
                },
              },
            })
          end,
        },
      },
      mcp = require("config.codecompanion.mcp").config(),
    },
    config = function(_, opts)
      require("config.codecompanion.rules").setup_instruction_autocmd()

      opts.interactions.chat.slash_commands = {
        prompts = require("code-companion-picker").select_slash_command,
        tools = require("code-companion-picker").select_tool_slash_command,
        skills = require("code-companion-picker").select_skill_slash_command,
      }

      require("codecompanion").setup(opts)
    end,
    keys = {
      k_cmd({
        key = a .. "c",
        action = "CodeCompanionChat Toggle",
        desc = "Open Code Companion",
      }),
      k_cmd({
        key = a .. "o",
        action = "CodeCompanionChat",
        desc = "Open Code Companion Chat",
      }),
      k_cmd({
        key = a .. "O",
        action = "CodeCompanionChat Close",
        desc = "Close Code Companion",
      }),
      k_cmd({
        key = a .. "A",
        action = "CodeCompanionActions",
        desc = "Actions Pallete",
      }),
      k_cmd({
        key = a .. "i",
        action = "CodeCompanion",
        desc = "inline",
      }),
      k_cmd({
        key = a .. "l",
        action = "CodeCompanion /lsp",
        desc = "Explain LSP diagnostic",
      }),
      k({
        key = a .. "p",
        action = ":CodeCompanionPrompt ",
        desc = "Prompt Select",
      }),

      --
      -- Visual Mode
      --
      k_cmd({
        key = a .. "a",
        action = "CodeCompanionChat Add",
        desc = "Add visual selection to chat",
        mode = "v",
      }),
      k({
        key = a .. "c",
        action = ":CodeCompanion ",
        desc = "Chat about visual selection",
        mode = "v",
      }),
      k_cmd({
        key = a .. "e",
        action = "'<,'>CodeCompanionChat /explain",
        desc = "Explain visual selection",
      }),
      k_cmd({
        key = a .. "f",
        action = "'<,'>CodeCompanionChat /fix",
        desc = "Fix visual selection",
      }),
      k_cmd({
        key = a .. "i",
        action = "CodeCompanionChat Inline",
        desc = "inline visual selection",
        mode = "v",
      }),
      k_cmd({
        key = a .. "l",
        action = "'<,'>CodeCompanionChat /lsp",
        desc = "Explain LSP diagnostic for visual selection",
      }),
      k_cmd({
        key = a .. "t",
        action = "'<,'>CodeCompanionChat /tests",
        desc = "Test visual selection",
      }),
    },
  },
}

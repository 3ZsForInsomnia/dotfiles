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
      prompt_library = require("config.prompts"),
      extensions = {
        dap = {
          enabled = true,
        },
        history = {
          enabled = true,
          opts = {
            keymap = "gh",
            save_chat_keymap = "sc",
            auto_save = true,
            expiration_days = 0,
            picker = "snacks",
            chat_filter = nil, -- function(chat_data) return boolean end
            picker_keymaps = {
              rename = { n = "r", i = "<M-r>" },
              delete = { n = "d", i = "<M-d>" },
              duplicate = { n = "<C-y>", i = "<C-y>" },
            },
            auto_generate_title = false, -- use CodeCompanion's own title generation
            title_generation_opts = {
              adapter = nil, -- defaults to current chat adapter when nil
              model = nil, -- defaults to current chat model when nil
              refresh_every_n_prompts = 1, -- 10,
              max_refreshes = 1, -- 15,
              format_title = function(original_title)
                return original_title
              end,
            },
            continue_last_chat = false,
            delete_on_clearing_chat = false,
            dir_to_save = vim.fn.stdpath("data") .. "/codecompanion-history",
            enable_logging = false,

            summary = {
              create_summary_keymap = "gcs",
              browse_summaries_keymap = "gbs",

              generation_opts = {
                adapter = nil, -- defaults to current chat adapter
                model = nil, -- defaults to current chat model
                context_size = 128000, -- max tokens that the model supports
                include_references = true, -- include slash command content
                include_tool_outputs = true, -- include tool execution results
                system_prompt = nil, -- custom system prompt (string or function)
                format_summary = nil, -- custom function to format generated summary e.g to remove <think/> tags from summary
              },
            },

            memory = {
              auto_create_memories_on_summary_generation = true,
              vectorcode_exe = "vectorcode",
              tool_opts = {
                default_num = 10,
              },
              notify = true,
              index_on_startup = false,
            },
          },
        },
      },
      interactions = {
        chat = {
          opts = {
            completion_provider = "blink",
          },
          adapter = "claude_code",
          tools = {
            cmd_runner = {
              opts = {
                require_approval_before = false,
              },
            },
            read_file = {
              opts = {
                require_approval_before = false,
              },
            },
            grep_search = {
              opts = {
                require_approval_before = false,
              },
            },
            list_files = {
              opts = {
                require_approval_before = false,
              },
            },
            fetch = {
              opts = {
                require_approval_before = false,
              },
            },
            mcp__vectorcode__query = {
              opts = {
                require_approval_before = false,
              },
            },
            mcp__vectorcode__ls = {
              opts = {
                require_approval_before = false,
              },
            },
          },
          keymaps = {
            close = {
              modes = {
                n = "asdkhbafjasbfhksf",
                i = "aksjfbgaljsfvbqbe",
              },
            },
          },
          roles = {
            llm = function(adapter)
              local model = ""
              if adapter and adapter.schema and adapter.schema.model and adapter.schema.model.default then
                local default_model = adapter.schema.model.default
                if type(default_model) == "function" then
                  local status, result = pcall(default_model, adapter)
                  model = status and result or ""
                else
                  model = tostring(default_model)
                end
              end

              local cc_tokens = require("token-count.integrations.codecompanion")
              local tokens = cc_tokens.get_estimated_tokens(vim.api.nvim_get_current_buf())
              local model_str = model ~= "" and (" (" .. model .. ")") or ""
              local token_str = tokens and (" | Tokens: " .. tokens) or ""

              return adapter.formatted_name .. model_str .. token_str
            end,
            user = "Me",
          },
          variables = {},
        },
        inline = {
          adapter = cc_models.local_adapter,
          variables = {},
        },
        background = {
          adapter = {
            name = cc_models.local_adapter,
            model = cc_models.local_model,
          },
          chat = {
            callbacks = {
              ["on_ready"] = {
                actions = {
                  "interactions.background.builtin.chat_make_title",
                },
                enabled = true,
              },
            },
            opts = {
              enabled = true,
            },
          },
        },
      },
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
      mcp = require("config.codecompanion.mcp")(),
    },
    config = function(_, opts)
      require("token-count.integrations.codecompanion").setup()

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

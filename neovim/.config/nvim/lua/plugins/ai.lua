local k_cmd = require("helpers").k_cmd
local k = require("helpers").k

local a = "<leader>a"

return {
  {
    "zbirenbaum/copilot.lua",
    event = "InsertEnter",
    config = true,
    opts = {
      filetypes = {
        ["*"] = true,
      },
    },
  },
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
          description = 'Personal rules and code philosophy. This is really my "system" prompt',
          files = {
            vim.fn.stdpath("config") .. "/lua/config/prompts/personal-programming.md",
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
        log_level = "ERROR",
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
        -- vectorcode = {
        --   opts = {
        --     tool_group = {
        --       -- this will register a tool group called `@vectorcode_toolbox` that contains all 3 tools
        --       enabled = true,
        --       -- a list of extra tools that you want to include in `@vectorcode_toolbox`.
        --       -- if you use @vectorcode_vectorise, it'll be very handy to include
        --       -- `file_search` here.
        --       extras = {},
        --       collapse = false, -- whether the individual tools should be shown in the chat
        --     },
        --     tool_opts = {
        --       ["*"] = {},
        --       ls = {},
        --       vectorise = {},
        --       query = {
        --         max_num = { chunk = 80, document = 20 },
        --         default_num = { chunk = 50, document = 10 },
        --         include_stderr = false,
        --         use_lsp = true,
        --         no_duplicate = true,
        --         chunk_mode = true,
        --         summarise = {
        --           enabled = false,
        --           adapter = nil,
        --           query_augmented = true,
        --         },
        --       },
        --       files_ls = {},
        --       files_rm = {},
        --     },
        --   },
        -- },
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
        -- opts = {
        --   collapse_tools = true,
        --   interval_ms = 1000,
        --   winfixbuf = true,
        --
        --   tool_opts = {
        --     evaluate = {
        --       require_approval_before = true,
        --     },
        --     source = {
        --       prefer_filesystem = true,
        --     },
        --   },
        -- },
      },
      interactions = {
        chat = {
          opts = {
            completion_provider = "blink",
          },
          adapter = "anthropic_acp",
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
          adapter = "qwen25_7b",
          variables = {},
        },
        background = {
          adapter = {
            name = "default_copilot",
            model = "claude-sonnet-4-6",
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
          default_copilot = function()
            return require("codecompanion.adapters").extend("copilot", {
              schema = {
                model = {
                  order = 1,
                  type = "enum",
                  desc = "Select one of your curated Copilot-backed models",
                  default = "claude-sonnet-4.6",
                  choices = {
                    ["claude-sonnet-4.6"] = { opts = { provider = "anthropic" } },
                    ["claude-opus-4.6"] = { opts = { provider = "anthropic" } },
                    ["gpt-5-2025-08-07"] = { opts = { provider = "openai", tier = "flagship" } },
                    ["o4-mini"] = { opts = { provider = "openai", can_reason = true, reasoning_tier = "mini" } },
                    ["gemini-2.5-pro"] = { opts = { provider = "google", multimodal = true } },
                    -- ["gemini-3-pro-preview"] = { opts = { provider = "google", multimodal = true } },
                  },
                },
              },
            })
          end,
          qwen25_7b = function()
            return require("codecompanion.adapters").extend("ollama", {
              name = "qwen25_7b",
              schema = {
                model = {
                  default = "qwen2.5:7b-instruct",
                  choices = {
                    "qwen2.5:7b-instruct",
                    "qwen2.5:7b",
                  },
                },
                num_ctx = { default = 16384 },
                temperature = { default = 0.2 }, -- lower for deterministic inline transformations
                keep_alive = { default = "1h" }, -- keep model in memory for responsiveness
                -- 'think' only if your build advertises reasoning capability; leave false otherwise
                think = { default = false },
              },
            })
          end,
          anthropic = function()
            return require("codecompanion.adapters").extend("anthropic", {
              env = {
                CLAUDE_CODE_OAUTH_TOKEN = "CLAUDE_CODE_TOKEN",
              },
            })
          end,
        },
        acp = {
          copilot_acp = function()
            return require("codecompanion.adapters").extend("copilot_acp", {
              defaults = {
                timeout = 20000,
                mcpServers = "inherit_from_config",
              },
            })
          end,
          anthropic_acp = function()
            return require("codecompanion.adapters").extend("claude_code", {
              env = {
                CLAUDE_CODE_OAUTH_TOKEN = "CLAUDE_CODE_TOKEN",
              },
              defaults = {
                mcpServers = "inherit_from_config",
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

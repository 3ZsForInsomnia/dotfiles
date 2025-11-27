local k_cmd = require("helpers").k_cmd
local k = require("helpers").k
local cc_vars = require("config.codecompanion-variables")

local a = "<leader>a"

return {
  {
    "zbirenbaum/copilot.lua",
    event = "InsertEnter",
    config = true,
    opts = {
      copilot_model = "gpt-5",
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
    "ravitemer/mcphub.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    build = "npm install -g mcp-hub@latest",
    config = function()
      local gh_pat = os.getenv("GITHUB_PERSONAL_ACCESS_TOKEN")
      local global_env = {
        ["input:github_pat_mcp"] = gh_pat,
      }

      require("mcphub").setup({
        global_env = global_env,
      })
    end,
  },
  {
    "3ZsForInsomnia/token-count.nvim",
    -- dir = "~/src/token-count.nvim",
    event = "VeryLazy",
    config = true,
    opts = {
      model = "claude-4.5-sonnet",
      -- model = "gpt-5",
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
        "3ZsForInsomnia/vs-code-companion",
        -- dir = "~/src/vs-code-companion",
        cmd = "VsccImport",
      },
      {
        "3ZsForInsomnia/code-companion-picker",
        -- dir = "~/src/code-companion-picker",
        cmd = "CodeCompanionPrompts",
      },
    },
    opts = {
      opts = {
        log_level = "ERROR",
        system_prompt = require("config.prompts.personal-programming").main_system_prompt(),
      },
      display = {
        chat = {
          start_in_insert_mode = true,
          window = {
            opts = {
              cursorline = true,
              foldcolumn = "3",
              numberwidth = 3,
              spell = true,
            },
          },
        },
      },
      prompt_library = {
        -- System Prompts
        ["System: Personal Programming"] = require("config.prompts.personal-programming").selectable_prompt,
        ["System: Hobbies"] = require("config.prompts.hobbies"),
        ["System: Emotional Processing"] = require("config.prompts.personal-processing"),
        ["System: Daily Planning"] = require("config.prompts.daily-weekly").dailyPlanning,
        ["System: Review Notes Daily"] = require("config.prompts.daily-weekly").dailyReview,
        ["System: Review Notes Weekly"] = require("config.prompts.daily-weekly").weeklyReview,

        -- Specialized Assistants
        ["AI Rabbi"] = require("config.prompts.ai-rabbi"),

        -- Software Development
        ["Debugging"] = require("config.prompts.debugging"),
        ["Code Review"] = require("config.prompts.code-review"),
        ["Api Design"] = require("config.prompts.api-design"),
        ["System Architecture"] = require("config.prompts.sys-arch-docs"),
        ["Architecture Review"] = require("config.prompts.arch-review"),
        ["Technical Writing"] = require("config.prompts.technical-writing"),

        -- Project Management
        ["Story Writing"] = require("config.prompts.stories"),
        ["Process Improvements"] = require("config.prompts.process-retros"),
        ["Meeting: Prep"] = require("config.prompts.meetings").meeting_prep,
        ["Meeting: Cleanup"] = require("config.prompts.meetings").meeting_cleanup,

        -- Knowledge Management
        ["Notes: File (Remote)"] = require("config.prompts.note-filing").note_file_remote,
        ["Notes: File (Local)"] = require("config.prompts.note-filing").note_file_local,
        ["AI Review: Biweekly"] = require("config.prompts.ai-usage-review").biweekly,
        ["AI Review: Quarterly"] = require("config.prompts.ai-usage-review").quarterly,

        -- Hebrew Learning
        ["Hebrew: Vocab Cards"] = require("config.prompts.hebrew-cards").vocab,
        ["Hebrew: Grammar Cards"] = require("config.prompts.hebrew-cards").grammar,
        ["Hebrew: Function Words"] = require("config.prompts.hebrew-cards").function_words,

        -- Code Examples
        ["Code: Snippet"] = require("config.prompts.coding-examples").snippet,
        ["Code: Good vs Bad"] = require("config.prompts.coding-examples").good_bad_example,

        -- Tools & Retrieval
        ["Web: Fetch & Summarize"] = require("config.prompts.retrieval").web_fetch,
        ["VC: Extract Keywords & Query"] = require("config.prompts.vectorcode").vc_extract_keywords,
        ["VC: Search with Summary"] = require("config.prompts.vectorcode").vc_search_summary,
        ["VC: Raw File List"] = require("config.prompts.vectorcode").vc_search_raw,
      },
      extensions = {
        vectorcode = {
          opts = {
            tool_group = {
              -- this will register a tool group called `@vectorcode_toolbox` that contains all 3 tools
              enabled = false,
              -- a list of extra tools that you want to include in `@vectorcode_toolbox`.
              -- if you use @vectorcode_vectorise, it'll be very handy to include
              -- `file_search` here.
              extras = {},
              collapse = false, -- whether the individual tools should be shown in the chat
            },
            tool_opts = {
              ["*"] = {},
              ls = {},
              vectorise = {},
              query = {
                max_num = { chunk = 80, document = 20 },
                default_num = { chunk = 50, document = 10 },
                include_stderr = false,
                use_lsp = true,
                no_duplicate = true,
                chunk_mode = true,
                summarise = {
                  enabled = false,
                  adapter = nil,
                  query_augmented = true,
                },
              },
              files_ls = {},
              files_rm = {},
            },
          },
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
            auto_generate_title = true,
            title_generation_opts = {
              adapter = nil, -- defaults to current chat adapter
              model = nil, -- defaults to current chat model
              refresh_every_n_prompts = 10,
              max_refreshes = 15,
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
                context_size = 90000, -- max tokens that the model supports
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
        mcphub = {
          callback = "mcphub.extensions.codecompanion",
          opts = {
            -- MCP Tools
            make_tools = true, -- Make individual tools (@server__tool) and server groups (@server) from MCP servers
            show_server_tools_in_chat = true, -- Show individual tools in chat completion (when make_tools=true)
            add_mcp_prefix_to_tool_names = false, -- Add mcp__ prefix (e.g `@mcp__github`, `@mcp__neovim__list_issues`)
            show_result_in_chat = true, -- Show tool results directly in chat buffer
            format_tool = nil, -- function(tool_name:string, tool: CodeCompanion.Agent.Tool) : string Function to format tool names to show in the chat buffer
            -- MCP Resources
            make_vars = true, -- Convert MCP resources to #variables for prompts
            -- MCP Prompts
            make_slash_commands = true, -- Add MCP prompts as /slash commands
          },
        },
      },
      strategies = {
        chat = {
          opts = {
            completion_provider = "blink",
          },
          adapter = {
            name = "copilot",
            -- model = "gemini-3-pro-preview",
            -- model = "gemini-2.5-pro",
            -- model = "claude-sonnet-4.5",
            model = "gpt-5",
          },
          variables = {
            date = cc_vars.date,
            vccharter = cc_vars.vccharter,
            vccurrproj = cc_vars.vccurrproj,
            vcnotes = cc_vars.vcnotes,
            vcwork = cc_vars.vcwork,
            qnotes = cc_vars.qnotes,
            qwork = cc_vars.qwork,
          },
          keymaps = {
            close = {
              modes = {
                n = "asdkhbafjasbfhksf",
                i = "aksjfbgaljsfvbqbe",
              },
            },
          },
        },
        inline = {
          adapter = "qwen25_7b",
          variables = {
            date = cc_vars.date,
            vccharter = cc_vars.vccharter,
            vccurrproj = cc_vars.vccurrproj,
            vcnotes = cc_vars.vcnotes,
            vcwork = cc_vars.vcwork,
            qnotes = cc_vars.qnotes,
            qwork = cc_vars.qwork,
          },
          keymaps = {
            accept_change = {
              modes = { n = "ga" },
              description = "Accept the suggested change",
            },
            reject_change = {
              modes = { n = "gr" },
              opts = { nowait = true },
              description = "Reject the suggested change",
            },
          },
        },
      },
      -- memory = {
      --   opts = {
      --     chat = {
      --       enabled = true,
      --     },
      --   },
      --   default = {
      --     description = "Common memory files",
      --     files = {},
      --   },
      -- },
      adapters = {
        http = {
          opts = {
            show_model_choices = true,
          },
          default_copilot = function()
            require("codecompanion.adapters").extend("copilot", {
              schema = {
                model = {
                  order = 1,
                  type = "enum",
                  desc = "Select one of your curated Copilot-backed models",
                  default = "claude-sonnet-4.5",
                  choices = {
                    ["claude-sonnet-4.5"] = { opts = { provider = "anthropic" } },
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
        },
      },
    },
    config = function(_, opts)
      opts.strategies.chat.slash_commands = {
        prompts = require("code-companion-picker").select_slash_command,
        tools = require("code-companion-picker").select_tool_slash_command,
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

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
      model = "claude-4-sonnet",
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
        -- "3ZsForInsomnia/vs-code-companion",
        dir = "~/src/vs-code-companion",
        cmd = "VsccImport",
      },
      {
        -- "3ZsForInsomnia/code-companion-picker",
        dir = "~/src/code-companion-picker",
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
        ["System: Personal Programming"] = require("config.prompts.personal-programming").selectable_prompt,
        ["System: Hobbies"] = require("config.prompts.hobbies"),
        ["System: Emotional Processing"] = require("config.prompts.personal-processing"),
        ["System: Daily Planning"] = require("config.prompts.daily-weekly").dailyPlanning,
        ["System: Review Notes Daily"] = require("config.prompts.daily-weekly").dailyReview,
        ["System: Review Notes Weekly"] = require("config.prompts.daily-weekly").weeklyReview,
        ["Debugging"] = require("config.prompts.debugging"),
        ["Story Writing"] = require("config.prompts.stories"),
        ["Api Design"] = require("config.prompts.api-design"),
        ["System Architecture"] = require("config.prompts.sys-arch-docs"),
        ["Architecture Review"] = require("config.prompts.arch-review"),
        ["Technical Writing"] = require("config.prompts.technical-writing"),
        ["Meeting Prep"] = require("config.prompts.meeting-prep"),
        ["Process Improvements"] = require("config.prompts.process-retros"),
        ["Code Review"] = require("config.prompts.code-review"),
      },
      extensions = {
        vectorcode = {
          ---@type VectorCode.CodeCompanion.ExtensionOpts
          opts = {
            tool_group = {
              -- this will register a tool group called `@vectorcode_toolbox` that contains all 3 tools
              enabled = true,
              -- a list of extra tools that you want to include in `@vectorcode_toolbox`.
              -- if you use @vectorcode_vectorise, it'll be very handy to include
              -- `file_search` here.
              extras = {},
              collapse = false, -- whether the individual tools should be shown in the chat
            },
            tool_opts = {
              ---@type VectorCode.CodeCompanion.ToolOpts
              ["*"] = {},
              ---@type VectorCode.CodeCompanion.LsToolOpts
              ls = {},
              ---@type VectorCode.CodeCompanion.VectoriseToolOpts
              vectorise = {},
              ---@type VectorCode.CodeCompanion.QueryToolOpts
              query = {
                max_num = { chunk = -1, document = -1 },
                default_num = { chunk = 50, document = 10 },
                include_stderr = false,
                use_lsp = false,
                no_duplicate = true,
                chunk_mode = false,
                ---@type VectorCode.CodeCompanion.SummariseOpts
                summarise = {
                  ---@type boolean|(fun(chat: CodeCompanion.Chat, results: VectorCode.QueryResult[]):boolean)|nil
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
            model = "claude-sonnet-4",
            -- model = "claude-sonnet-4.5",
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
          adapter = {
            name = "copilot",
            -- model = "claude-sonnet-4.5",
            model = "claude-sonnet-4",
          },
          keymaps = {
            accept_change = {
              modes = { n = "ga" },
              description = "Accept the suggested change",
            },
            reject_change = {
              modes = { n = "gr" },
              description = "Reject the suggested change",
            },
          },
        },
      },
      memory = {
        opts = {
          chat = {
            enabled = true,
          },
        },
        default = {
          description = "Common memory files",
          files = {},
        },
      },
    },
    config = function(_, opts)
      opts.strategies.chat.slash_commands = {
        prompts = require("code-companion-picker").select_slash_command,
        tools = require("code-companion-picker").select_tool_slash_command,
        -- import = ...
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
        desc = "add visual selection",
        mode = "v",
      }),
      k_cmd({
        key = a .. "i",
        action = "CodeCompanionChat Inline",
        desc = "inline visual selection",
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

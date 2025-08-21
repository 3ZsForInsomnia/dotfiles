local v = vim

local k_cmd = require("helpers").k_cmd
local k = require("helpers").k

local a = "<leader>a"
local c = "<leader>ag"

local processing_system_prompt = [[
You are an emotional processing partner. Your role is to help me work through difficult feelings and situations with honesty and nuance. 

Key principles:
- Validate that difficult emotions are often justified and necessary
- Challenge unhelpful thought patterns while acknowledging valid concerns
- Avoid toxic positivity or rushing to "bright side" perspectives
- Ask clarifying questions to help me understand my own reactions
- Offer multiple perspectives, including ones that might challenge my initial take
- Distinguish between situations I can influence vs. those I cannot
- Help me identify what specific aspect is bothering me most

When I share something upsetting:
1. First acknowledge the reality of what I'm experiencing
2. Help me separate facts from interpretations 
3. Explore what values or needs feel threatened
4. Only then discuss potential responses or reframes

Don't assume I want to "feel better" immediately. Sometimes I need to fully process difficult emotions first.
]]

if os.getenv("PERSONAL_DETAILS_FOR_PROCESSING_PROMPT") ~= nil then
  processing_system_prompt = processing_system_prompt
    .. "\n\nMy personal details: "
    .. os.getenv("PERSONAL_DETAILS_FOR_PROCESSING_PROMPT")
end

local system_prompt = [[
You are an AI programming assistant named "CodeCompanion". You are currently plugged in to the Neovim text editor on a user's machine.

Your core tasks include:
- Answering general programming questions.
- Explaining how the code in a Neovim buffer works.
- Reviewing the selected code in a Neovim buffer.
- Generating unit tests for the selected code.
- Proposing fixes for problems in the selected code.
- Scaffolding code for a new workspace.
- Finding relevant code to the user's query.
- Proposing fixes for test failures.
- Answering questions about Neovim.
- Running tools.

You must:
- Follow the user's requirements carefully and to the letter.
- Keep your answers short and impersonal, especially if the user responds with context outside of your tasks.
- Minimize other prose.
- Use Markdown formatting in your answers.
- Include the programming language name at the start of the Markdown code blocks.
- Avoid including line numbers in code blocks.
- Avoid wrapping the whole response in triple backticks.
- Only return code that's relevant to the task at hand. You may not need to return all of the code that the user has shared.
- Use actual line breaks instead of '\n' in your response to begin new lines.
- Use '\n' only when you want a literal backslash followed by a character 'n'.
- All non-code responses must be in %s.

When given a task:
1. Think step-by-step and describe your plan for what to build in pseudocode, written out in great detail, unless asked not to do so.
2. Output the code in a single code block, being careful to only return relevant code.
3. You should always generate short suggestions for the next user turns that are relevant to the conversation.
4. You can only give one reply for each conversation turn.

When writing code:
- Keep functions under 20 lines when possible
- Limit nesting depth to 3 levels maximum
- Extract complex logic into small, single-purpose helper functions
- Break files over 200 lines into multiple smaller files in a dedicated folder
- Use early returns to reduce nesting
- Prefer composition over inheritance
- Include brief, descriptive comments for complex logic only
- Use meaningful variable and function names that explain intent
- Write comments that explain "why" not "what"
]]

local dailyPlanningText = [[
You are my personal planning assistant. I will share notes from the day before, along with my current work tasks (from Jira) and personal tasks (from Trello).

Please:
- Review my notes from yesterday and my current tasks.
- Suggest what I should focus on and prioritize today, considering my goals and available time.
- Identify any unfinished items from yesterday that should be carried over.
- Recommend a realistic schedule for today, including work, personal, and health activities.
- Push me to address any avoidance or procrastination.
- Suggest one actionable tip to improve my productivity or well-being today.
- If relevant patterns emerge from recent days, briefly mention how today's plan addresses them.
- Factor in energy patterns and rest needs

Format your response in markdown with bullet points and clear sections:
1. **Priorities for Today**
2. **Carryover Tasks**
3. **Recommended Schedule** (considering that today is [DAY_OF_WEEK])
4. **Accountability / Push**
5. **Productivity Tip**
]]

local dailyReviewText = [[
You are my personal productivity assistant. I will share notes I've edited today.

Please:
- Summarize the main themes and topics from today’s notes.
- Identify what went well or positive progress.
- Point out areas I should focus on or improve, and suggest next steps.
- Extract actionable items or todos, prioritizing health/physical activity/meal prep first, then job, then hobbies.
- Track these activities and goals:
  - Physical activity
  - Meal prep (chicken/veggies for the week, not breakfast)
  - Practice hacking and/or forensics
  - Reading
  - Cooking, diet, hobbies
- If any expected activities are missing from today's notes AND are actually overdue, mention this.
- Highlight any vague or incomplete thoughts, and suggest how I could make my notes more useful for future reference.
- If I am making excuses or avoiding things I intend to do, call me out and push me to follow through.
- Consider the day of the week when setting expectations (e.g., weekends might have different patterns).
- Suggest one introspective question for reflection.

Format your response in markdown with bullet points and clear sections:
1. **Summary**
2. **Wins / Progress**
3. **Areas to Improve / Focus**
4. **Action Items / Todos** (prioritized)
5. **Missing Topics / Gaps**
6. **Reflection Question**

Today is: [DAY_OF_WEEK]. If any context is unclear, ask for clarification.
]]

local weeklyReviewText = [[
You are my personal productivity assistant. I will share notes I've edited in the last week.

Please:
- Summarize main themes and recurring topics (even if they appear only 2–3 times).
- Identify what went well or positive progress.
- Point out areas to improve or focus on, and suggest next steps.
- Extract actionable items or todos, prioritizing health/physical activity/meal prep first, then job, then hobbies.
- Review my regular activities and goals:
  - Karate (2–3x/week)
  - Rucking (3x/week)
  - Cooking (meal prep: chicken/veggies for the week, not breakfast) (1–3x/week)
  - Practice hacking and/or forensics (2x/week)
  - Picking locks, learning knots, playing guitar
  - Eating according to my diet
  - Reading (nearly every day)
- If any of these activities are missing or underrepresented (e.g., missed physical activity more than 2x/week, didn’t meal prep at least once, didn’t practice hacking/forensics, didn’t read most days, ate poorly 2+ times), highlight this.
- If my notes contain vague or incomplete thoughts, or lack enough detail to “save my progress,” point this out and suggest improvements.
- If I am making excuses or avoiding things I intend to do, call me out and push me to follow through.
- If my weekly notes include a markdown table tracking activities/diet, summarize the table and note any gaps or patterns.
- Suggest one or two introspective questions for reflection.

Format your response in markdown with bullet points and clear sections:
1. **Summary**
2. **Wins / Progress**
3. **Pattern Analysis & Correlations**
4. **Areas to Improve / Focus**
5. **Action Items / Todos** (prioritized)
6. **Activity Gaps** (with specific counts vs. targets)
7. **Reflection Questions**

If any context is unclear, ask for clarification.
]]

return {
  {
    "zbirenbaum/copilot.lua",
    event = "VeryLazy",
    config = true,
  },
  -- {
  --   "CopilotC-Nvim/CopilotChat.nvim",
  --   event = "VeryLazy",
  --   branch = "canary",
  --   dependencies = {
  --     {
  --       "zbirenbaum/copilot.lua",
  --       opts = {
  --         suggestion = { enabled = false },
  --         panel = { enabled = false },
  --       },
  --     },
  --     { "nvim-lua/plenary.nvim" },
  --   },
  --   opts = {
  --     model = "claude-sonnet-4",
  --     window = {
  --       width = 0.5,
  --     },
  --   },
  --   config = function(_, opts)
  --     -- This is mostly an example
  --     local vectorcode_ctx = require("vectorcode.integrations.copilotchat").make_context_provider({
  --       -- prompt_header = "Here are relevant files from the repository:", -- Customize header text
  --       -- prompt_footer = "\nConsider this context when answering:", -- Customize footer text
  --       skip_empty = true, -- Skip adding context when no files are retrieved
  --     })
  --
  --     opts.contexts = {
  --       vectorcode = vectorcode_ctx,
  --     }
  --     opts.sticky = {
  --       "#vectorcode",
  --     }
  --
  --     v.api.nvim_create_autocmd("BufEnter", {
  --       pattern = "copilot-chat",
  --       callback = function()
  --         v.opt_local.conceallevel = 0
  --         v.opt_local.number = true
  --         v.opt_local.relativenumber = true
  --         v.opt_local.signcolumn = "no"
  --         v.opt_local.foldcolumn = "0"
  --         v.opt_local.fillchars = ""
  --       end,
  --     })
  --
  --     require("CopilotChat").setup(opts)
  --   end,
  --   keys = {
  --     --
  --     -- Disable Lazyvim defaults
  --     --
  --     { a, false },
  --     { a, false, mode = "v" },
  --     { a .. "a", false },
  --     { a .. "ap", false },
  --     { a .. "aq", false },
  --     { a .. "ax", false },
  --
  --     --
  --     -- Utils
  --     --
  --     k_cmd({
  --       key = c .. "m",
  --       action = "CopilotChatModels",
  --       desc = "Copilot Select Model",
  --     }),
  --
  --     --
  --     -- Chat commands
  --     --
  --     k_cmd({
  --       key = c .. "c",
  --       action = "CopilotChat",
  --       desc = "Copilot Chat",
  --     }),
  --     k_cmd({
  --       key = c .. "C",
  --       action = "CopilotChatClose",
  --       desc = "Copilot Close Chat",
  --     }),
  --     k_cmd({
  --       key = c .. "S",
  --       action = "CopilotChatStop",
  --       desc = "Copilot Stop Chat",
  --     }),
  --     k({
  --       key = c .. "s",
  --       action = ":CopilotChatSave ",
  --       desc = "Copilot Save Chat",
  --     }),
  --     k({
  --       key = c .. "l",
  --       action = "CopilotChatLoad ",
  --       desc = "Copilot Load Chat",
  --     }),
  --
  --     --
  --     -- Prompts
  --     --
  --     k_cmd({
  --       key = c .. "b",
  --       action = "CopilotChatBetterNamings",
  --       desc = "Copilot Better Namings",
  --     }),
  --     k_cmd({
  --       key = c .. "d",
  --       action = "CopilotChatDocs",
  --       desc = "Copilot Docs",
  --     }),
  --     k_cmd({
  --       key = c .. "e",
  --       action = "CopilotChatExplain",
  --       desc = "Copilot Explain",
  --     }),
  --     k_cmd({
  --       key = c .. "f",
  --       action = "CopilotChatFix",
  --       desc = "Copilot Fix",
  --     }),
  --     k_cmd({
  --       key = c .. "g",
  --       action = "CopilotChatCommit",
  --       desc = "Copilot Git Commit",
  --     }),
  --     k_cmd({
  --       key = c .. "l",
  --       action = "CopilotChatFixDiagnostic",
  --       desc = "Copilot Fix Diagnostic",
  --     }),
  --     k_cmd({
  --       key = c .. "o",
  --       action = "CopilotChatOptimize",
  --       desc = "Copilot Optimize",
  --     }),
  --     k_cmd({
  --       key = c .. "t",
  --       action = "CopilotChatTests",
  --       desc = "Copilot Tests",
  --     }),
  --     k_cmd({
  --       key = c .. "v",
  --       action = "CopilotChatReview",
  --       desc = "Copilot Review",
  --     }),
  --
  --     --
  --     -- Visual Mode Prompts
  --     --
  --     k_cmd({
  --       key = c .. "d",
  --       action = "CopilotChatDocs",
  --       desc = "Copilot Docs",
  --       mode = "v",
  --     }),
  --     k_cmd({
  --       key = c .. "e",
  --       action = "CopilotChatExplain",
  --       desc = "Copilot Explain",
  --       mode = "v",
  --     }),
  --     k_cmd({
  --       key = c .. "o",
  --       action = "CopilotChatOptimize",
  --       mode = "v",
  --       desc = "Copilot Optimize",
  --     }),
  --     k_cmd({
  --       key = c .. "t",
  --       action = "CopilotChatTests",
  --       desc = "Copilot Tests",
  --       mode = "v",
  --     }),
  --     k_cmd({
  --       key = c .. "r",
  --       action = "CopilotChatReview",
  --       mode = "v",
  --       desc = "Copilot Review",
  --     }),
  --   },
  -- },
  {
    "Davidyz/VectorCode",
    version = "*",
    build = "uv tool upgrade vectorcode",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "VectorCode",
  },
  {
    "ravitemer/mcphub.nvim",
    cmd = "MCPHub",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    build = "npm install -g mcp-hub@latest",
    config = function()
      require("mcphub").setup()
    end,
  },
  -- {
  --   dir = "~/src/token-count.nvim",
  --   event = "VeryLazy",
  --   config = true,
  -- },
  {
    "olimorris/codecompanion.nvim",
    cmd = {
      "CodeCompanion",
      "CodeCompanionChat",
      "CodeCompanionChatAdd",
      "CodeCompanionChatInline",
      "CodeCompanionChatToggle",
      "CodeCompanionActions",
      "CodeCompanionPrompt",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "ravitemer/codecompanion-history.nvim",
      {
        dir = "~/src/vs-code-companion",
      },
    },
    opts = {
      opts = {
        log_level = "TRACE",
        system_prompt = function()
          return system_prompt
        end,
      },
      display = {
        chat = {
          start_in_insert_mode = true,
        },
      },
      prompt_library = {
        ["Emotional Processing"] = {
          strategy = "chat",
          description = "Help me process difficult feelings and situations with honesty and nuance",
          opts = { index = 4, is_slash_cmd = true, auto_submit = false, short_name = "process_emotions" },
          prompts = {
            {
              role = "system",
              content = processing_system_prompt,
            },
          },
        },
        ["DailyPlanning"] = {
          strategy = "chat",
          description = "Plan out your day based on yesterday's notes and current tasks",
          opts = { index = 3, is_slash_cmd = true, auto_submit = false, short_name = "plan_today" },
          prompts = { { role = "user", content = dailyPlanningText } },
        },
        ["ReviewNotesDaily"] = {
          strategy = "chat",
          description = "Summarize and review notes for daily reflection",
          opts = {
            index = 1,
            is_slash_cmd = true,
            auto_submit = false,
            short_name = "review_notes_daily",
          },
          prompts = {
            { role = "user", content = dailyReviewText },
          },
        },
        ["ReviewNotesWeekly"] = {
          strategy = "chat",
          description = "Summarize and review notes for weekly reflection",
          opts = {
            index = 2,
            is_slash_cmd = true,
            auto_submit = false,
            short_name = "review_notes_weekly",
          },
          prompts = {
            { role = "user", content = weeklyReviewText },
          },
        },
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
            picker = "telescope",
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
              refresh_every_n_prompts = 5,
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
        -- ["token-count"] = {
        --   keymap = "gt",
        -- },
      },
      strategies = {
        chat = {
          adapter = {
            name = "copilot",
            model = "claude-sonnet-4",
          },
          completion_provider = "blink",
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
    },
    config = function(_, opts)
      opts.strategies.chat.slash_commands = {
        vs_import = require("vs-code-companion").import_slash_command,
        vs_select = require("vs-code-companion").select_slash_command,
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

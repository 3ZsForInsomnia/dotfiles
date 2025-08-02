local k_cmd = require("helpers").k_cmd
local k = require("helpers").k

local a = "<leader>a"

local dailyPlanningText = [[
You are my personal planning assistant. I will share notes from the day before, along with my current work tasks (from Jira) and personal tasks (from Trello).

Please:
- Review my notes from yesterday and my current tasks.
- Suggest what I should focus on and prioritize today, considering my goals and available time.
- Identify any unfinished items from yesterday that should be carried over.
- Recommend a realistic schedule for today, including work, personal, and health activities.
- Push me to address any avoidance or procrastination.
- Suggest one actionable tip to improve my productivity or well-being today.

Format your response in markdown with bullet points and clear sections:
1. **Priorities for Today**
2. **Carryover Tasks**
3. **Recommended Schedule**
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
- If any expected activities are missing from today’s notes, mention this.
- Highlight any vague or incomplete thoughts, and suggest how I could make my notes more useful for future reference.
- If I am making excuses or avoiding things I intend to do, call me out and push me to follow through.
- Suggest one introspective question for reflection.

Format your response in markdown with bullet points and clear sections:
1. **Summary**
2. **Wins / Progress**
3. **Areas to Improve / Focus**
4. **Action Items / Todos** (prioritized)
5. **Missing Topics / Gaps**
6. **Reflection Question**

If any context is unclear, ask for clarification.
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
3. **Areas to Improve / Focus**
4. **Action Items / Todos** (prioritized)
5. **Missing Topics / Gaps**
6. **Reflection Questions**

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
  --       key = a .. "m",
  --       action = "CopilotChatModels",
  --       desc = "Copilot Select Model",
  --     }),
  --
  --     --
  --     -- Chat commands
  --     --
  --     k_cmd({
  --       key = a .. "c",
  --       action = "CopilotChat",
  --       desc = "Copilot Chat",
  --     }),
  --     k_cmd({
  --       key = a .. "C",
  --       action = "CopilotChatClose",
  --       desc = "Copilot Close Chat",
  --     }),
  --     k_cmd({
  --       key = a .. "S",
  --       action = "CopilotChatStop",
  --       desc = "Copilot Stop Chat",
  --     }),
  --     k({
  --       key = a .. "s",
  --       action = ":CopilotChatSave ",
  --       desc = "Copilot Save Chat",
  --     }),
  --     k({
  --       key = a .. "l",
  --       action = "CopilotChatLoad ",
  --       desc = "Copilot Load Chat",
  --     }),
  --
  --     --
  --     -- Prompts
  --     --
  --     k_cmd({
  --       key = a .. "b",
  --       action = "CopilotChatBetterNamings",
  --       desc = "Copilot Better Namings",
  --     }),
  --     k_cmd({
  --       key = a .. "d",
  --       action = "CopilotChatDocs",
  --       desc = "Copilot Docs",
  --     }),
  --     k_cmd({
  --       key = a .. "e",
  --       action = "CopilotChatExplain",
  --       desc = "Copilot Explain",
  --     }),
  --     k_cmd({
  --       key = a .. "f",
  --       action = "CopilotChatFix",
  --       desc = "Copilot Fix",
  --     }),
  --     k_cmd({
  --       key = a .. "g",
  --       action = "CopilotChatCommit",
  --       desc = "Copilot Git Commit",
  --     }),
  --     k_cmd({
  --       key = a .. "l",
  --       action = "CopilotChatFixDiagnostic",
  --       desc = "Copilot Fix Diagnostic",
  --     }),
  --     k_cmd({
  --       key = a .. "o",
  --       action = "CopilotChatOptimize",
  --       desc = "Copilot Optimize",
  --     }),
  --     k_cmd({
  --       key = a .. "t",
  --       action = "CopilotChatTests",
  --       desc = "Copilot Tests",
  --     }),
  --     k_cmd({
  --       key = a .. "v",
  --       action = "CopilotChatReview",
  --       desc = "Copilot Review",
  --     }),
  --
  --     --
  --     -- Visual Mode Prompts
  --     --
  --     k_cmd({
  --       key = a .. "d",
  --       action = "CopilotChatDocs",
  --       desc = "Copilot Docs",
  --       mode = "v",
  --     }),
  --     k_cmd({
  --       key = a .. "e",
  --       action = "CopilotChatExplain",
  --       desc = "Copilot Explain",
  --       mode = "v",
  --     }),
  --     k_cmd({
  --       key = a .. "o",
  --       action = "CopilotChatOptimize",
  --       mode = "v",
  --       desc = "Copilot Optimize",
  --     }),
  --     k_cmd({
  --       key = a .. "t",
  --       action = "CopilotChatTests",
  --       desc = "Copilot Tests",
  --       mode = "v",
  --     }),
  --     k_cmd({
  --       key = a .. "r",
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
    "olimorris/codecompanion.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      log_level = "TRACE",
      display = {
        chat = {
          start_in_insert_mode = true,
          auto_scroll = false,
        },
      },
      prompt_library = {
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
      ---@module "vectorcode"
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
      },
      strategies = {
        chat = {
          opts = {
            completion_provider = "blink",
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
    keys = {
      k_cmd({
        key = a .. "c",
        action = "CodeCompanionChat Toggle",
        desc = "Open Code Companion",
      }),
      k_cmd({
        key = a .. "a",
        action = "CodeCompanionChat Add",
        desc = "Add buffer to Code Companion",
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

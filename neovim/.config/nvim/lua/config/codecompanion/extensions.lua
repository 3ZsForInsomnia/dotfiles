-- CodeCompanion extensions (dap + history).
--
-- Only non-default values are set here; fields that just restated the
-- library defaults (nil adapters/models, identity formatters, default
-- keymaps, default dirs) have been trimmed for legibility.
local cc_models = require("config.codecompanion.models")

return {
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
      picker_keymaps = {
        rename = { n = "r", i = "<M-r>" },
        delete = { n = "d", i = "<M-d>" },
        duplicate = { n = "<C-y>", i = "<C-y>" },
      },
      auto_generate_title = true,
      title_generation_opts = {
        -- Titles are cheap/disposable: generate them with the free local
        -- model instead of defaulting to the chat adapter (Opus over ACP).
        adapter = cc_models.local_adapter,
        model = cc_models.local_model,
        refresh_every_n_prompts = 8, -- re-title sparingly, not every message
        max_refreshes = 10, -- but let the name keep evolving across a long chat
      },
      continue_last_chat = false,
      delete_on_clearing_chat = false,
      dir_to_save = vim.fn.stdpath("data") .. "/codecompanion-history",

      summary = {
        create_summary_keymap = "gcs",
        browse_summaries_keymap = "gbs",
        generation_opts = {
          context_size = 128000, -- max tokens the summary model supports
          include_references = true, -- include slash command content
          include_tool_outputs = true, -- include tool execution results
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
}

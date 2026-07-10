-- Single source of truth for CodeCompanion model presets.
-- Imported by BOTH plugins/ai.lua (adapter definitions + strategy wiring) and
-- the prompt library (config/prompts). Change models/tuning here, nowhere else.
--
-- Remote presets route through the `claude_code` (ACP) adapter. Per-preset model
-- selection uses `acp_opts`, which CodeCompanion passes through as the ACP
-- session_config_options (deep-merged into the adapter's defaults) -- see
-- codecompanion/interactions/init.lua `add_adapter`. Models are chosen by
-- friendly name, so they track whatever the current model is -- no hardcoded
-- model IDs, no HTTP-key adapter.
-- NOTE: switching models mid-chat within the ACP adapter can reset the session.
-- That's Claude Code behavior, not something these presets control.
--
-- `local_model` is a local (Ollama) model, also used by minuet (text completion)
-- and CodeCompanion's inline + background strategies. One warm instance serves
-- all three; see plugins/ai.lua for the adapter and startup config for the
-- OLLAMA_* env vars that keep minuet and CodeCompanion on the same instance.
local M = {}

-- Local model tuning. To swap the local model, change M.local_model (and, if the
-- new model is a reasoning model, M.local_think). Nothing else needs to change.
M.local_adapter = "local_llm"
M.local_model = "codestral:22b-v0.1-q4_0"
M.local_num_ctx = 16384 -- keep in sync with OLLAMA_CONTEXT_LENGTH (startup)
M.local_temperature = 0.2
M.local_keep_alive = "1h"
M.local_think = false

-- Remote model selection (friendly names resolved by Claude Code).
-- remote_thinking_model is also the claude_code adapter's default in
-- plugins/ai.lua, so the default chat and the `thinking` preset stay in sync.
M.remote_thinking_model = "opus"
M.remote_non_thinking_model = "sonnet"
M.remote_thought_level = "medium"

M.models = {
  thinking = {
    name = "claude_code",
    acp_opts = { model = M.remote_thinking_model, thought_level = M.remote_thought_level },
  },
  non_thinking = {
    name = "claude_code",
    acp_opts = { model = M.remote_non_thinking_model, thought_level = M.remote_thought_level },
  },
  local_model = { name = M.local_adapter },
}

return M

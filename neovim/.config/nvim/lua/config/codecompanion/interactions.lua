-- CodeCompanion interaction strategies (chat / inline / background).
--
-- Chat runs over the ACP claude_code adapter; inline + background use the
-- local Ollama model (see config.codecompanion.models). Tool approvals are
-- split by domain: CodeCompanion's own built-in tools live here, MCP server
-- tool approvals are owned by config.codecompanion.mcp and merged in below.
local cc_models = require("config.codecompanion.models")
local mcp = require("config.codecompanion.mcp")

-- Built-in CodeCompanion tools that should skip the approval prompt.
local builtin_tool_approvals = {
  cmd_runner = { opts = { require_approval_before = false } },
  read_file = { opts = { require_approval_before = false } },
  grep_search = { opts = { require_approval_before = false } },
  list_files = { opts = { require_approval_before = false } },
  fetch = { opts = { require_approval_before = false } },
}

return {
  chat = {
    opts = {
      completion_provider = "blink",
    },
    adapter = "claude_code",
    -- Built-in tool approvals + this MCP server's tool approvals.
    tools = vim.tbl_extend("error", builtin_tool_approvals, mcp.tool_approvals),
    keymaps = {
      close = {
        modes = {
          n = "asdkhbafjasbfhksf",
          i = "aksjfbgaljsfvbqbe",
        },
      },
    },
    roles = {
      -- Show the adapter name + model in the chat header. Token counting is
      -- intentionally omitted: the chat adapter is ACP (claude_code), where
      -- token-count estimation doesn't apply.
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

        local model_str = model ~= "" and (" (" .. model .. ")") or ""
        return adapter.formatted_name .. model_str
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
}

local v = vim

local function cwd_name()
  return v.fn.fnamemodify(v.fn.getcwd(), ":t")
end

local function in_any_of(repos)
  return v.tbl_contains(repos, cwd_name())
end

local servers = {
  ["anki-mcp"] = {
    cmd = { "anki-mcp-http", "--stdio" },
    env = {
      ANKI_CONNECT_URL = "http://localhost:8765",
    },
  },

  ["github"] = {
    cmd = {
      "docker",
      "run",
      "-i",
      "--rm",
      "-e",
      "GITHUB_PERSONAL_ACCESS_TOKEN",
      "ghcr.io/github/github-mcp-server",
    },
  },

  ["kubernetes"] = {
    cmd = { "npx", "mcp-server-kubernetes" },
  },

  ["mui-mcp"] = {
    cmd = { "npx", "-y", "@mui/mcp@latest" },
  },

  ["nx"] = {
    cmd = { "npx", "nx-mcp@latest" },
  },

  ["playwright"] = {
    cmd = { "npx", "@playwright/mcp@latest" },
  },

  ["tavily"] = {
    cmd = {
      "npx",
      "-y",
      "mcp-remote",
      "https://mcp.tavily.com/mcp/?tavilyApiKey=" .. os.getenv("TAVILY_API_KEY"),
    },
  },

  ["atlassian"] = {
    cmd = { "npx", "-y", "mcp-remote", "https://mcp.atlassian.com/v1/mcp" },
  },

  ["figma"] = {
    cmd = { "npx", "-y", "mcp-remote", "http://127.0.0.1:3845/mcp" },
  },

  ["sunsama"] = {
    cmd = { "npx", "-y", "mcp-remote", "https://api.sunsama.com/mcp" },
  },

  ["dbhub-demo"] = {
    cmd = { "npx", "-y", "@bytebase/dbhub", "--transport", "stdio", "--demo" },
  },

  ["dbhub-jira-ai"] = {
    cmd = {
      "npx",
      "-y",
      "@bytebase/dbhub",
      "--transport",
      "stdio",
      "--dsn",
      "sqlite:///Users/zacharylevinw/.local/share/nvim/jira-ai/jira_ai.db",
    },
  },

  ["dbhub-plat"] = {
    cmd = {
      "npx",
      "-y",
      "@bytebase/dbhub",
      "--transport",
      "stdio",
      "--dsn",
      os.getenv("DBHUB_PLAT_DSN"),
    },
  },

  ["dbhub-revman"] = {
    cmd = {
      "npx",
      "-y",
      "@bytebase/dbhub",
      "--transport",
      "stdio",
      "--dsn",
      "sqlite:///Users/zacharylevinw/.local/state/nvim/revman/revman.db",
    },
  },

  ["mcp-obsidian"] = {
    cmd = { "uvx", "mcp-obsidian" },
  },

  ["webmcp"] = {
    cmd = {
      "npx",
      "-y",
      "@jason.today/webmcp@latest",
      "--mcp",
    },
  },
}

local default_servers = {
  -- "sunsama",
}

-- Org rules block GitHub MCP auth in work repos, so it only loads outside them.
local personal_servers = {
  "github",
}

local work_repos = { "platform", "platform-2", "infrastructure", "specification" }
local work_servers = {
  "atlassian",
  "dbhub-plat",
  "figma",
  "kubernetes",
  "nx",
  "playwright",
}

v.list_extend(default_servers, in_any_of(work_repos) and work_servers or personal_servers)

local M = {}

-- Approval overrides for this server's MCP tools. Lives here (not in
-- interactions.lua) because "which MCP tools skip the chat approval prompt" is
-- an MCP-domain decision; interactions.lua merges these with CodeCompanion's
-- own built-in tool approvals at assembly time.
M.tool_approvals = {}

function M.acp_servers()
  return v.tbl_map(function(name)
    local cmd = servers[name].cmd
    return { name = name, command = cmd[1], args = v.list_slice(cmd, 2), env = servers[name].env or {} }
  end, default_servers)
end

function M.config()
  return {
    servers = servers,
    opts = {
      -- Empty on purpose: CodeCompanion starts its own copy of every default
      -- server whenever any chat opens, even ACP chats where Claude runs its
      -- own. ACP sessions get default_servers through acp_servers() instead.
      default_servers = {},
    },
  }
end

return M

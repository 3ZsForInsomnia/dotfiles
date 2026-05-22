local v = vim

local function cwd_name()
  return v.fn.fnamemodify(v.fn.getcwd(), ":t")
end

local function add_when_in(default_servers, server_name, repos)
  if v.tbl_contains(repos, cwd_name()) then
    table.insert(default_servers, server_name)
  end

  return default_servers
end

local servers = {
  ["anki-mcp"] = {
    cmd = { "anki-mcp-http", "--stdio" },
    env = {
      ANKI_CONNECT_URL = "http://localhost:8765",
    },
  },

  ["git-mcp"] = {
    cmd = { "npx", "@cyanheads/git-mcp-server@latest" },
    env = {
      GIT_EMAIL = "zach@zjlevine.dev",
      GIT_USERNAME = "3ZsForInsomnia",
      LOGS_DIR = "~/.local/state/git-mcp/logs/",
      MCP_LOG_LEVEL = "info",
      MCP_TRANSPORT_TYPE = "stdio",
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
    env = {
      GITHUB_PERSONAL_ACCESS_TOKEN = os.getenv("GITHUB_PERSONAL_ACCESS_TOKEN"),
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
    cmd = { "npx", "-y", "mcp-remote", "https://mcp.atlassian.com/v1/sse" },
  },

  ["figma"] = {
    cmd = { "npx", "-y", "mcp-remote", "http://127.0.0.1:3845/mcp" },
  },

  ["sunsama"] = {
    cmd = { "npx", "-y", "mcp-remote", "https://api.sunsama.com/mcp" },
  },

  ["basic-memory"] = {
    cmd = { "uvx", "basic-memory", "mcp" },
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

  ["vectorcode"] = {
    cmd = { "vectorcode-mcp-server" },
  },
}

local default_servers = {
  "vectorcode",
  "nx",
}

add_when_in(default_servers, "nx", {
  "platform",
  "platform-2",
})

return function()
  return {
    servers = servers,
    opts = {
      default_servers = default_servers,
    },
  }
end

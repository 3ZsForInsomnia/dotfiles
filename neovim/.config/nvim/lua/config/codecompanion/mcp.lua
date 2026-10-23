local v = vim

local cwd = v.fn.getcwd()
local repo_root = v.fs.root(cwd, ".git")

local in_work = v.startswith(cwd .. "/", v.fn.expand("~/src/work") .. "/")
local in_notes = repo_root == v.fn.expand("~/Documents/sync")
local uses_nx = repo_root ~= nil and v.uv.fs_stat(repo_root .. "/nx.json") ~= nil

local function in_repo(name)
  return repo_root ~= nil and v.fs.basename(repo_root) == name
end

local function when(condition, names)
  return condition and names or {}
end

local function concat(...)
  return v.iter({ ... }):flatten():totable()
end

-- Servers the Docker MCP gateway runs, named as in Docker's MCP catalog or in
-- docker/catalog.yaml next to this file (installed by `mcp-catalog-sync`). The
-- gateway lists their tools at startup but only runs a server's container
-- during a tool call, or for the whole session if its catalog entry is
-- long-lived.
local gateway_servers = concat(
  when(in_work, { "atlassian-remote", "dbhub-plat", "mui", "playwright" }),
  when(in_notes, { "anki" }),
  when(in_repo("revman.nvim"), { "dbhub-revman" }),
  when(in_repo("jira-ai"), { "dbhub-jira-ai" })
)
local has_gateway_servers = #gateway_servers > 0

-- Host folders the gateway may mount writable: the dbhub SQLite databases'
-- folders, matching the volumes in docker/catalog.yaml.
local writable_mounts = {
  v.fn.expand("~/.local/state/nvim/revman"),
  v.fn.expand("~/.local/share/nvim/jira-ai"),
}

local servers = {
  ["docker-gateway"] = {
    cmd = {
      "docker",
      "mcp",
      "gateway",
      "run",
      "--catalog",
      "docker-mcp.yaml",
      "--catalog",
      "dotfiles.yaml",
      "--tools-config",
      v.fn.stdpath("config") .. "/lua/config/codecompanion/docker/tools.yaml",
      "--servers",
      table.concat(gateway_servers, ","),
    },
    env = {
      MCP_GATEWAY_DOCKER_BIND_ALLOW_WRITABLE_PATHS = table.concat(writable_mounts, ":"),
    },
  },

  -- Outside the gateway, which only accepts https remotes: the Figma desktop
  -- app serves its MCP endpoint over plain http on localhost.
  ["figma"] = {
    cmd = { "npx", "-y", "mcp-remote", "http://127.0.0.1:3845/mcp" },
  },

  ["nx"] = {
    cmd = { "npx", "nx-mcp@latest" },
  },

  ["playwright-extension"] = {
    cmd = { "npx", "@playwright/mcp@latest", "--extension" },
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

local default_servers = concat(
  when(has_gateway_servers, { "docker-gateway" }),
  { "webmcp" },
  when(in_work, { "figma", "playwright-extension" }),
  when(uses_nx, { "nx" })
)

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

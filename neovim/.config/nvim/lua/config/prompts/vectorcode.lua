-- VectorCode prompts
--
-- Retrieval prompts:
--   1. Inline: Extract keywords & query
--   2. Chat: Search with summary + sources
--   3. Chat: Raw file listing
--
-- Routing prompts (converted from variables):
--   Inject collection routing instructions into a chat message.

local S = require("config.prompts.shared")

--------------------------------------------------
-- Routing helpers
--------------------------------------------------

local function git_root()
  local cwd = vim.fn.getcwd()
  local ok, out = pcall(vim.fn.systemlist, { "git", "-C", cwd, "rev-parse", "--show-toplevel" })
  if ok and type(out) == "table" and out[1] and out[1] ~= "" then
    return out[1]
  end
  return cwd
end

local function work_root()
  return os.getenv("W_PATH") .. "/platform"
end

local charter_text = [[
**VectorCode Collection Router**

Use these rules to select the project_root value for @{vectorcode_query} based on query intent.
Default: If no project_root specified, @vectorcode_query uses the current git root.
]]

local function current_project_text()
  return string.format(
    [[
Query Current Project using %s when querying:
- Code patterns, implementations, architecture, API designs, service structures, data models
- Existing functions, modules, related files, technical documentation, inline comments
- Test files, CI/CD configurations, deployment scripts, version history
]],
    git_root()
  )
end

local function notes_text()
  return string.format(
    [[
Query Notes Collection using %s when querying:
- Meeting notes, project decisions, retrospectives, past conversations, planning notes
- Technical documentation, ADRs, design discussions, architecture decisions
- Personal research, learning resources, references, status updates
]],
    S.notes_root
  )
end

local function work_text()
  return string.format(
    [[
Query Work Codebase using %s when querying:
- Work-specific code patterns, microservice implementations, production API designs
- Work service structures, shared libraries, architecture decisions, existing work functions
- Work CI/CD pipelines, deployment configurations, version/release management
]],
    work_root()
  )
end

local function full_routing_text()
  return charter_text .. "\n" .. current_project_text() .. "\n" .. notes_text() .. "\n" .. work_text()
end

local function quick_notes_text()
  return string.format('@vectorcode_query project_root="%s"', S.notes_root)
end

local function quick_work_text()
  return string.format('@vectorcode_query project_root="%s"', work_root())
end

--------------------------------------------------
-- Inline: Extract Keywords & Query
--------------------------------------------------
local vc_extract_keywords_text = [[
Extract 3-6 relevant keywords from the provided text and search for related content.

Query parameters:
- num=4
- chunk_mode=true

Output format:
Keywords: <comma-separated keywords>

File paths:
- <path/to/file1>
- <path/to/file2>
- ...

Summary:
<Brief summary of findings from the retrieved chunks>
]]

local vc_extract_keywords = {
  strategy = "inline",
  description = "VectorCode: Extract keywords from selection and query",
  opts = { placement = "new" },
  prompts = {
    { role = "user", content = vc_extract_keywords_text },
  },
}

--------------------------------------------------
-- Chat: Search with Summary
--------------------------------------------------
local vc_search_summary = {
  strategy = "chat",
  description = "VectorCode: Search with summary and sources",
  opts = {
    adapter = S.remote_adapter,
    auto_submit = false,
  },
  prompts = {
    {
      role = "user",
      content = function()
        return "Search for relevant context based on my query.\n\n"
          .. full_routing_text()
          .. "\nUse chunk_mode=true for more granular results.\n\n"
          .. "Provide:\n"
          .. "1. A concise summary synthesizing the retrieved content\n"
          .. "2. Create inline wiki-links [[path/to/file]] where relevant\n"
          .. S.sources_format
      end,
    },
  },
}

--------------------------------------------------
-- Chat: Raw File Listing
--------------------------------------------------
local vc_search_raw = {
  strategy = "chat",
  description = "VectorCode: Raw file listing",
  opts = {
    adapter = S.remote_adapter,
    auto_submit = false,
  },
  prompts = {
    {
      role = "user",
      content = function()
        return "Search for files and return a minimal listing (no summary, no contents).\n\n"
          .. full_routing_text()
          .. "\nReturn just file paths with one-line descriptions.\n"
          .. "Create inline wiki-links [[path/to/file]].\n"
          .. S.sources_format
      end,
    },
  },
}

return {
  -- Retrieval
  vc_extract_keywords = vc_extract_keywords,
  vc_search_summary = vc_search_summary,
  vc_search_raw = vc_search_raw,

  -- Routing
  vc_routing = {
    strategy = "chat",
    description = "VectorCode: Full routing charter (current project + notes + work)",
    opts = { is_slash_cmd = true, auto_submit = false, short_name = "vc_routing" },
    prompts = { { role = "user", content = full_routing_text } },
  },
  vc_route_current = {
    strategy = "chat",
    description = "VectorCode: Route to current project",
    opts = { is_slash_cmd = true, auto_submit = false, short_name = "vc_route_current" },
    prompts = {
      {
        role = "user",
        content = function()
          return "@{vectorcode_query}\n\n" .. current_project_text()
        end,
      },
    },
  },
  vc_route_notes = {
    strategy = "chat",
    description = "VectorCode: Route to notes collection",
    opts = { is_slash_cmd = true, auto_submit = false, short_name = "vc_route_notes" },
    prompts = {
      {
        role = "user",
        content = function()
          return "@{vectorcode_query}\n\n" .. notes_text()
        end,
      },
    },
  },
  vc_route_work = {
    strategy = "chat",
    description = "VectorCode: Route to work codebase",
    opts = { is_slash_cmd = true, auto_submit = false, short_name = "vc_route_work" },
    prompts = {
      {
        role = "user",
        content = function()
          return "@{vectorcode_query}\n\n" .. work_text()
        end,
      },
    },
  },
  vc_quick_notes = {
    strategy = "chat",
    description = "VectorCode: Quick query notes collection",
    opts = { is_slash_cmd = true, auto_submit = false, short_name = "vc_quick_notes" },
    prompts = { { role = "user", content = quick_notes_text } },
  },
  vc_quick_work = {
    strategy = "chat",
    description = "VectorCode: Quick query work codebase",
    opts = { is_slash_cmd = true, auto_submit = false, short_name = "vc_quick_work" },
    prompts = { { role = "user", content = quick_work_text } },
  },
}

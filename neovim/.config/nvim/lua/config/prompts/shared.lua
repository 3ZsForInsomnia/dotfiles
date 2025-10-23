-- Shared variables and adapters for CodeCompanion prompt modules.
-- Naming conventions (for prompt table keys):
--   VectorCode prompts: vc_<type>_<local|remote>[ _notes]
--     types: summary, raw
--     _notes = use notes_root as project_root
--   Web fetch / buffer: web_fetch_<local|remote>, buffer_<local|remote>_<chat|new>
--   Code examples: snippet_<local|remote>, good_bad_code_example_<local|remote>
--
-- Each prompt's text lives in a <key>_text variable immediately above the
-- prompt config (<key>) for readability.
--
-- Local prompts omit an adapter (your inline default = local model).
-- Remote prompts specify the remote adapter table.

local home = os.getenv("HOME") or ""
local notes_root = home .. "/Documents/sync"

-- Bibliography rules inserted where needed
local biblio_text = [[
Number each line:
[<n>]: <basename_or_relpath> - <one short line summary>
If no results: No results.
Do not invent files.
]]

-- Adapters
-- local adapter intentionally omitted in prompts (uses your inline default)
-- local remote_adapter = { name = "default_copilot", model = "claude-sonnet-4.5" }
local remote_adapter = { name = "default_copilot" }

-- Sources section format for VectorCode-enhanced prompts
local sources_format = [[

## Sources
Cite all VectorCode results and referenced files using footnotes:
[^1]: path/to/file.md
  - Brief description of content
  - Why it's relevant to this context
  - (1-3 bullets total per source)
]]

-- Callout usage guidelines
local callout_usage = [[
Use Obsidian callouts sparingly (roughly 1 per 50 lines of content):
- `> [!important]` for critical decisions or information
- `> [!todo]` for key action items needing emphasis
- `> [!question]` for unresolved questions or open items
Don't overuse - save for truly important items.
]]

-- Date-aware VectorCode querying instructions
local date_aware_query = [[
Current date: #{date}

When querying VectorCode, prefer recent context:
1. After getting VectorCode results, use ${full_stack_dev} to check file modification times
2. Prioritize files modified within last 3 months unless older files are highly relevant
3. Focus on recent context for meeting notes and project discussions
]]

-- Confluence/Jira search tools availability
local confluence_jira_tools = [[
You have access to Atlassian tools for additional context:
- ${atlassian_mcp_server__searchConfluenceUsingCql} - Search Confluence documentation
- ${atlassian_mcp_server__searchJiraIssuesUsingJql} - Search Jira tickets/issues
- ${atlassian_mcp_server__getJiraIssue} - Get specific Jira ticket details

Use these tools when relevant to gather context beyond notes.
]]

return {
  home = home,
  notes_root = notes_root,
  biblio_text = biblio_text,
  remote_adapter = remote_adapter,
  sources_format = sources_format,
  callout_usage = callout_usage,
  date_aware_query = date_aware_query,
  confluence_jira_tools = confluence_jira_tools,
}

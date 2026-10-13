-- Shared variables and adapters for CodeCompanion prompt modules.
-- Naming conventions (for prompt table keys):
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

-- Sources section format for prompts that pull in context from other files
local sources_format = [[

## Sources
Cite all referenced files using footnotes:
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

return {
  home = home,
  notes_root = notes_root,
  biblio_text = biblio_text,
  sources_format = sources_format,
  callout_usage = callout_usage,
}

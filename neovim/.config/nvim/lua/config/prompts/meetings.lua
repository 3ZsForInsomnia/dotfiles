-- Meeting preparation and cleanup prompts
-- Both use VectorCode for context enhancement, Confluence/Jira when relevant
-- Remote adapter for complex synthesis and formatting
--
-- Prompts:
--   - meeting_prep: Prepare for meetings or create project status snapshots
--   - meeting_cleanup: Clean up and enhance meeting notes with better formatting

local S = require("config.prompts.shared")

--------------------------------------------------
-- Meeting Preparation
--------------------------------------------------
local function get_meeting_prep_text()
  return "You are my meeting preparation partner. I will provide details about an upcoming meeting (or project status review) and a file path where you should create the preparation notes.\n\n"
    .. "**Your task:**\n"
    .. "1. Extract keywords and context from my meeting description\n"
    .. "2. Query VectorCode strategically - you decide whether to make:\n"
    .. "   - One broad query for general context\n"
    .. "   - Multiple targeted queries (e.g., 'previous meetings with X', 'project Y notes', 'topic Z context')\n"
    .. "   - Whatever query strategy makes sense for this specific meeting\n"
    .. "3. Use Confluence/Jira tools when relevant for additional context\n"
    .. "4. Populate the provided file with:\n\n"
    .. "**File Structure:**\n"
    .. "## Summary\n"
    .. "Synthesize key context from VectorCode results - what was discussed previously, current state, relevant background\n\n"
    .. "## Agenda\n"
    .. "- Bullet points by default (I'll ask for numbered/time-boxed if needed)\n"
    .. "- Include FOLLOW-UP items from previous meetings as agenda items with 'FOLLOW-UP:' prefix\n"
    .. "- Generally 1-2 follow-ups maximum per meeting\n\n"
    .. "## Next Steps\n"
    .. "Template for next steps to be decided during meeting\n\n"
    .. S.sources_format
    .. "\n\n"
    .. "**Additional Guidelines:**\n"
    .. S.date_aware_query
    .. "\n"
    .. S.callout_usage
    .. "\n"
    .. S.confluence_jira_tools
    .. "\n\n"
    .. "**Important:**\n"
    .. "- Create inline wiki-links [[path/to/file]] where relevant\n"
    .. "- Use ${full_stack_dev} for file operations\n"
    .. "- All VectorCode queries use project_root=\""
    .. S.notes_root
    .. '"\n'
    .. "- Extract action items from previous meetings using pattern recognition (not TODO markers)\n"
    .. "- After writing the file, confirm: 'Created prep notes at: <path>'\n\n"
    .. "**Note:** This prompt is primarily for meetings but can also be used to create project status snapshots or 'where are we now' documents."
end

local meeting_prep = {
  strategy = "chat",
  description = "Prepare for meetings or create project status snapshots with VectorCode context",
  opts = {
    adapter = S.remote_adapter,
    auto_submit = false,
    is_slash_cmd = true,
    short_name = "meeting_prep",
  },
  prompts = {
    {
      role = "user",
      content = get_meeting_prep_text(),
      contains_code = true,
    },
  },
}

--------------------------------------------------
-- Meeting Notes Cleanup
--------------------------------------------------
local function get_meeting_cleanup_text()
  return "You are my meeting notes cleanup assistant. I will provide a file path containing raw meeting notes that need enhancement and better formatting.\n\n"
    .. "**Your task:**\n"
    .. "1. Read the raw meeting notes from the provided file\n"
    .. "2. Extract keywords and context from the notes\n"
    .. "3. Query VectorCode strategically for related context (you decide query approach)\n"
    .. "4. Use Confluence/Jira tools when relevant\n"
    .. "5. Enhance and reformat the notes\n\n"
    .. "**Enhancement approach (moderate to aggressive reorganization):**\n"
    .. "- Add markdown headers to break up sections thematically\n"
    .. "- Reorganize chronological bullets into logical groupings\n"
    .. "- Maintain recognizability - don't completely rewrite, just restructure\n"
    .. "- Detect when unordered lists should be ordered/numbered\n"
    .. "- Extract action items into dedicated section using 'TODO: <person> will...' format\n"
    .. "- Add 'Follow-up Items' section if there are items to revisit next time\n"
    .. "- Weave in relevant context from VectorCode results inline where it fits\n"
    .. "- Add context that doesn't fit inline to appropriate sections\n\n"
    .. "**Code examples:**\n"
    .. "- Generate actual code examples if discussed AND you have high confidence\n"
    .. "- If unsure, skip rather than add placeholder/bad examples\n"
    .. "- Better to omit than to add something I'll delete\n\n"
    .. "**Formatting:**\n"
    .. "- Create inline wiki-links [[path/to/file]] where relevant\n"
    .. S.callout_usage
    .. "\n"
    .. S.sources_format
    .. "\n\n"
    .. "**Additional Guidelines:**\n"
    .. S.date_aware_query
    .. "\n"
    .. S.confluence_jira_tools
    .. "\n\n"
    .. "**Important:**\n"
    .. "- All VectorCode queries use project_root=\""
    .. S.notes_root
    .. '"\n'
    .. "- Use ${full_stack_dev} for file operations\n"
    .. "- Sources section goes at very end, even after Action Items/Follow-ups\n"
    .. "- Files in Sources should use wiki-links inline where relevant (but don't have to)\n"
    .. "- Files with inline wiki-links should appear in Sources\n"
    .. "- After updating file, confirm: 'Enhanced notes at: <path>'"
end

local meeting_cleanup = {
  strategy = "chat",
  description = "Clean up and enhance meeting notes with better formatting and context",
  opts = {
    adapter = S.remote_adapter,
    auto_submit = false,
    is_slash_cmd = true,
    short_name = "meeting_cleanup",
  },
  prompts = {
    {
      role = "user",
      content = get_meeting_cleanup_text(),
      contains_code = true,
    },
  },
}

return {
  meeting_prep = meeting_prep,
  meeting_cleanup = meeting_cleanup,
}

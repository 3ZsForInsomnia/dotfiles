-- Note filing prompts: take meeting notes and file them to appropriate location.
-- Remote chat version: uses VectorCode for context enhancement, creates wiki-links
-- Local inline version: simple reformatting without VectorCode (token constraints)
--
-- Both versions:
--   - Default location (if not specified): 1 - Work/13 - Meetings/<person>/<today>.md
--   - Person inferred from first line of notes
--   - Uses ${full_stack_dev} for file read/write operations
--   - Creates new file and populates with enhanced/reformatted notes

local S = require("config.prompts.shared")

-- Helper to get today's date in the format matching daily notes
local function get_today_filename()
  return os.date("%Y-%m-%d %A") .. ".md"
end

--------------------------------------------------
-- Note Filing REMOTE (chat, full-featured)
--------------------------------------------------
local function get_note_file_remote_text()
  local text = "You will help me file meeting notes from my daily notes into the appropriate permanent location.\n\n"
    .. "**Your task:**\n"
    .. "1. Read the provided notes (visual selection)\n"
    .. "2. Extract keywords from the notes for context retrieval\n"
    .. "3. Query VectorCode with those keywords to find related previous notes/meetings\n"
    .. "4. Enhance the notes with 1-2 additional bullet points based on VectorCode results\n"
    .. "5. Create Obsidian wiki-style links to relevant files found by VectorCode (format: [[path/to/file]])\n"
    .. "6. Determine the destination file path\n"
    .. "7. Create the file and write the enhanced notes\n\n"
    .. "**Default file location** (if user doesn't specify):\n"
    .. "  "
    .. S.notes_root
    .. "/1 - Work/13 - Meetings/<person>/<filename>\n\n"
    .. "  Where:\n"
    .. '  - <person>: Inferred from the first line of notes (e.g., "Danica sync" → "13.03 - Danica" folder)\n'
    .. "  - <filename>: "
    .. get_today_filename()
    .. " (today's date unless user specifies otherwise)\n\n"
    .. "**Guidelines:**\n"
    .. "- If you cannot infer the person/location with high confidence, ASK the user\n"
    .. '- Query VectorCode with EXACTLY: project_root="'
    .. S.notes_root
    .. '", relevant keywords from notes\n'
    .. "- Keep enhancements minimal (1-2 bullets max)\n"
    .. "- Format wiki-links as: [[relative/path/from/notes_root]]\n"
    .. "- Preserve the original structure and content of the notes\n"
    .. "- Add Sources section at the end with footnote citations\n"
    .. '- After writing the file, confirm the action: "Created: <full_path>"\n\n'
    .. "**Important:** The user may provide additional details about the destination in this chat. If they specify a path or filename, use that instead of defaults.\n\n"
    .. "Use @{full_stack_dev} tools for file operations and @vectorcode_query for context retrieval.\n\n"
    .. S.sources_format

  return text
end

local note_file_remote = {
  strategy = "chat",
  description = "File notes to person/meeting (remote, enhanced)",
  opts = {
    adapter = S.remote_adapter,
    auto_submit = false,
  },
  prompts = {
    {
      role = "system",
      content = function(context)
        return "You are helping organize meeting notes into a structured note system. Notes root: "
          .. S.notes_root
          .. "\nToday: "
          .. get_today_filename()
      end,
    },
    {
      role = "user",
      content = get_note_file_remote_text(),
      contains_code = true,
    },
  },
}

--------------------------------------------------
-- Note Filing LOCAL (inline, simple)
--------------------------------------------------
local function get_note_file_local_text()
  local text = "File these meeting notes to the appropriate location with basic formatting.\n\n"
    .. "**Your task:**\n"
    .. "1. Read the provided notes\n"
    .. "2. Reformat and organize them for clarity (fix bullets, grouping, etc.)\n"
    .. "3. Determine destination file path\n"
    .. "4. Create the file and write the reformatted notes\n\n"
    .. "**Default file location** (if not obvious from context):\n"
    .. "  "
    .. S.notes_root
    .. "/1 - Work/13 - Meetings/<person>/"
    .. get_today_filename()
    .. "\n\n"
    .. "  Where:\n"
    .. '  - <person>: Inferred from first line of notes (e.g., "Danica sync" → "13.03 - Danica")\n\n'
    .. "**Guidelines:**\n"
    .. "- Work within meetings folder only (1 - Work/13 - Meetings/...)\n"
    .. '- If person cannot be inferred clearly, use "Unknown" folder\n'
    .. "- Keep formatting simple and clean\n"
    .. "- Preserve original content, just organize better\n"
    .. '- Confirm action: "Created: <full_path>"\n\n'
    .. "Use @{full_stack_dev} tools for file operations."

  return text
end

local note_file_local = {
  strategy = "inline",
  description = "File notes to person/meeting (local, simple)",
  opts = {
    placement = "new",
  },
  prompts = {
    {
      role = "user",
      content = get_note_file_local_text(),
      contains_code = true,
    },
  },
}

return {
  note_file_remote = note_file_remote,
  note_file_local = note_file_local,
}

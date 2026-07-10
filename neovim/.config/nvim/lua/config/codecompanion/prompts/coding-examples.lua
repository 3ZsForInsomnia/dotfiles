-- Code example generation prompts (chat-based for dynamic input)
-- Uses local LLM for quick, simple examples
-- Chat prompts that don't auto-submit (prompt as starting point)
--
-- Prompts:
--   - snippet: Simple code examples
--   - good_bad_example: Good vs Bad pattern comparisons

--------------------------------------------------
-- Simple Code Snippet
--------------------------------------------------
local snippet_text = [[
Create a minimal, focused code example based on my description.

Guidelines:
- Single fenced code block (markdown) if it's code
- Plain text if non-code
- After the example: blank line + SHORT explanation (1-4 sentences)
- No extra sections or headings
- Keep it simple and directly relevant
]]

local snippet = {
  strategy = "chat",
  description = "Code snippet (quick example)",
  opts = {
    auto_submit = false,
  },
  prompts = {
    { role = "user", content = snippet_text },
  },
}

--------------------------------------------------
-- Good vs Bad Example
--------------------------------------------------
local good_bad_example_text = [[
Create a Good vs Bad code comparison in ONE fenced code block.

Inside the single code block:
- Use language-appropriate comments (// or #) to label sections
- Good version first
- Blank line
- Bad version second

After the code block (blank line):
- Short explanation (up to 3 paragraphs):
  * Why Good is better
  * Issues with Bad
  * One concise heuristic/rule of thumb

Keep code minimal and focused.
]]

local good_bad_example = {
  strategy = "chat",
  description = "Good vs Bad code comparison",
  opts = {
    auto_submit = false,
  },
  prompts = {
    { role = "user", content = good_bad_example_text },
  },
}

return {
  snippet = snippet,
  good_bad_example = good_bad_example,
}

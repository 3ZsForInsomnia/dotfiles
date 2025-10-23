-- Web fetch and summarization prompt (chat-based for dynamic URL input)
-- Remote adapter for better summarization quality
-- Placement: new buffer for easy reference/copy

local S = require("config.prompts.shared")

--------------------------------------------------
-- Web Fetch & Summarize (REMOTE)
--------------------------------------------------
local web_fetch_text = [[
Extract the URL from my message and fetch the webpage content.

Use @{fetch_webpage} tool with the extracted URL.

Output format:
URL: <the_url>

<Concise summary of the page content>

Guidelines:
- Keep summary focused and actionable
- No extra headings
- If fetch fails, report: "Fetch failed: <reason>"
]]

local web_fetch = {
  strategy = "chat",
  description = "Fetch webpage and summarize",
  opts = {
    auto_submit = false,
  },
  prompts = {
    { role = "user", content = web_fetch_text },
  },
}

return {
  web_fetch = web_fetch,
}

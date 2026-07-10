-- Index of all prompts registered in CodeCompanion's prompt_library.
-- Add new prompts here so they appear in the picker / actions palette.
return {
  -- "System" Prompts
  ["System: Personal Programming"] = require("config.codecompanion.prompts.personal-programming").selectable_prompt,
  ["System: Hobbies"] = require("config.codecompanion.prompts.hobbies"),
  ["System: Emotional Processing"] = require("config.codecompanion.prompts.personal-processing"),
  ["System: Daily Planning"] = require("config.codecompanion.prompts.daily-weekly").dailyPlanning,
  ["System: Review Notes Daily"] = require("config.codecompanion.prompts.daily-weekly").dailyReview,
  ["System: Review Notes Weekly"] = require("config.codecompanion.prompts.daily-weekly").weeklyReview,
  ["System: Critical Thinking"] = require("config.codecompanion.prompts.critical-thinking"),

  -- Software Development
  ["Debugging"] = require("config.codecompanion.prompts.debugging"),
  ["Code Review"] = require("config.codecompanion.prompts.code-review"),
  ["Api Design"] = require("config.codecompanion.prompts.api-design"),
  ["System Architecture"] = require("config.codecompanion.prompts.sys-arch-docs"),
  ["Architecture Review"] = require("config.codecompanion.prompts.arch-review"),
  ["Technical Writing"] = require("config.codecompanion.prompts.technical-writing"),
  ["Blueprint Mode"] = require("config.codecompanion.prompts.blueprint-mode"),
  ["Principal Engineer"] = require("config.codecompanion.prompts.principal-engineer"),

  -- Project Management
  ["Story Writing"] = require("config.codecompanion.prompts.stories"),
  ["Process Improvements"] = require("config.codecompanion.prompts.process-retros"),
  ["Meeting: Prep"] = require("config.codecompanion.prompts.meetings").meeting_prep,
  ["Meeting: Cleanup"] = require("config.codecompanion.prompts.meetings").meeting_cleanup,

  -- Knowledge Management
  ["Notes: File (Remote)"] = require("config.codecompanion.prompts.note-filing").note_file_remote,
  ["Notes: File (Local)"] = require("config.codecompanion.prompts.note-filing").note_file_local,
  ["AI Review: Biweekly"] = require("config.codecompanion.prompts.ai-usage-review").biweekly,
  ["AI Review: Quarterly"] = require("config.codecompanion.prompts.ai-usage-review").quarterly,

  -- Hebrew Learning
  ["Hebrew: Vocab Cards"] = require("config.codecompanion.prompts.hebrew-cards").vocab,
  ["Hebrew: Grammar Cards"] = require("config.codecompanion.prompts.hebrew-cards").grammar,
  ["Hebrew: Function Words"] = require("config.codecompanion.prompts.hebrew-cards").function_words,
  ["AI Rabbi"] = require("config.codecompanion.prompts.ai-rabbi"),

  -- Code Examples
  ["Code: Snippet"] = require("config.codecompanion.prompts.coding-examples").snippet,
  ["Code: Good vs Bad"] = require("config.codecompanion.prompts.coding-examples").good_bad_example,

  -- Tools & Retrieval
  ["Web: Fetch & Summarize"] = require("config.codecompanion.prompts.retrieval").web_fetch,
  ["VC: Extract Keywords & Query"] = require("config.codecompanion.prompts.vectorcode").vc_extract_keywords,
  ["VC: Search with Summary"] = require("config.codecompanion.prompts.vectorcode").vc_search_summary,
  ["VC: Raw File List"] = require("config.codecompanion.prompts.vectorcode").vc_search_raw,
  ["VC: Full Routing"] = require("config.codecompanion.prompts.vectorcode").vc_routing,
  ["VC: Route Current Project"] = require("config.codecompanion.prompts.vectorcode").vc_route_current,
  ["VC: Route Notes"] = require("config.codecompanion.prompts.vectorcode").vc_route_notes,
  ["VC: Route Work"] = require("config.codecompanion.prompts.vectorcode").vc_route_work,
  ["VC: Quick Notes"] = require("config.codecompanion.prompts.vectorcode").vc_quick_notes,
  ["VC: Quick Work"] = require("config.codecompanion.prompts.vectorcode").vc_quick_work,
}

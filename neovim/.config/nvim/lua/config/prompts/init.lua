-- Index of all prompts registered in CodeCompanion's prompt_library.
-- Add new prompts here so they appear in the picker / actions palette.
return {
  -- "System" Prompts
  ["System: Personal Programming"] = require("config.prompts.personal-programming").selectable_prompt,
  ["System: Hobbies"] = require("config.prompts.hobbies"),
  ["System: Emotional Processing"] = require("config.prompts.personal-processing"),
  ["System: Daily Planning"] = require("config.prompts.daily-weekly").dailyPlanning,
  ["System: Review Notes Daily"] = require("config.prompts.daily-weekly").dailyReview,
  ["System: Review Notes Weekly"] = require("config.prompts.daily-weekly").weeklyReview,
  ["System: Critical Thinking"] = require("config.prompts.critical-thinking"),

  -- Software Development
  ["Debugging"] = require("config.prompts.debugging"),
  ["Code Review"] = require("config.prompts.code-review"),
  ["Api Design"] = require("config.prompts.api-design"),
  ["System Architecture"] = require("config.prompts.sys-arch-docs"),
  ["Architecture Review"] = require("config.prompts.arch-review"),
  ["Technical Writing"] = require("config.prompts.technical-writing"),
  ["Blueprint Mode"] = require("config.prompts.blueprint-mode"),
  ["Principal Engineer"] = require("config.prompts.principal-engineer"),

  -- Project Management
  ["Story Writing"] = require("config.prompts.stories"),
  ["Process Improvements"] = require("config.prompts.process-retros"),
  ["Meeting: Prep"] = require("config.prompts.meetings").meeting_prep,
  ["Meeting: Cleanup"] = require("config.prompts.meetings").meeting_cleanup,

  -- Knowledge Management
  ["Notes: File (Remote)"] = require("config.prompts.note-filing").note_file_remote,
  ["Notes: File (Local)"] = require("config.prompts.note-filing").note_file_local,
  ["AI Review: Biweekly"] = require("config.prompts.ai-usage-review").biweekly,
  ["AI Review: Quarterly"] = require("config.prompts.ai-usage-review").quarterly,

  -- Hebrew Learning
  ["Hebrew: Vocab Cards"] = require("config.prompts.hebrew-cards").vocab,
  ["Hebrew: Grammar Cards"] = require("config.prompts.hebrew-cards").grammar,
  ["Hebrew: Function Words"] = require("config.prompts.hebrew-cards").function_words,
  ["AI Rabbi"] = require("config.prompts.ai-rabbi"),

  -- Code Examples
  ["Code: Snippet"] = require("config.prompts.coding-examples").snippet,
  ["Code: Good vs Bad"] = require("config.prompts.coding-examples").good_bad_example,

  -- Tools & Retrieval
  ["Web: Fetch & Summarize"] = require("config.prompts.retrieval").web_fetch,
  ["VC: Extract Keywords & Query"] = require("config.prompts.vectorcode").vc_extract_keywords,
  ["VC: Search with Summary"] = require("config.prompts.vectorcode").vc_search_summary,
  ["VC: Raw File List"] = require("config.prompts.vectorcode").vc_search_raw,
}

-- Index of all prompts registered in CodeCompanion's prompt_library.
-- Add new prompts here so they appear in the picker / actions palette.
return {
  -- "System" Prompts
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

  -- Project Management
  ["Story Writing"] = require("config.codecompanion.prompts.stories"),
  ["Process Improvements"] = require("config.codecompanion.prompts.process-retros"),
  ["Meeting Prep"] = require("config.codecompanion.prompts.meetings").meeting_prep,
  ["Meeting Cleanup"] = require("config.codecompanion.prompts.meetings").meeting_cleanup,

  -- Knowledge Management
  ["Notes: File (Remote)"] = require("config.codecompanion.prompts.note-filing").note_file_remote,
  ["Notes: File (Local)"] = require("config.codecompanion.prompts.note-filing").note_file_local,

  -- Hebrew Learning
  ["Hebrew: Vocab Cards"] = require("config.codecompanion.prompts.hebrew-cards").vocab,
  ["Hebrew: Grammar Cards"] = require("config.codecompanion.prompts.hebrew-cards").grammar,
  ["Hebrew: Function Words"] = require("config.codecompanion.prompts.hebrew-cards").function_words,
  ["AI Rabbi"] = require("config.codecompanion.prompts.ai-rabbi"),

  -- Code Examples
  ["Code: Snippet"] = require("config.codecompanion.prompts.coding-examples").snippet,
  ["Code: Good vs Bad"] = require("config.codecompanion.prompts.coding-examples").good_bad_example,
}

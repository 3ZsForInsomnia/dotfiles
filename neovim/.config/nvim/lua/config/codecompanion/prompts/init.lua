-- Index of all prompts registered in CodeCompanion's prompt_library.
-- Add new prompts here so they appear in the picker / actions palette.
return {
  -- "System" Prompts
  ["System: Hobbies"] = require("config.codecompanion.prompts.hobbies"),
  ["System: Emotional Processing"] = require("config.codecompanion.prompts.personal-processing"),
  ["System: Critical Thinking"] = require("config.codecompanion.prompts.critical-thinking"),
  ["Learning"] = require("config.codecompanion.prompts.learning"),

  -- Software Development
  ["Debugging"] = require("config.codecompanion.prompts.debugging"),
  ["Api Design"] = require("config.codecompanion.prompts.api-design"),
  ["System Architecture"] = require("config.codecompanion.prompts.sys-arch-docs"),
  ["Architecture Review"] = require("config.codecompanion.prompts.arch-review"),
  ["Technical Writing"] = require("config.codecompanion.prompts.technical-writing"),

  -- Project Management
  ["Process Improvements"] = require("config.codecompanion.prompts.process-retros"),
  ["Meeting Prep"] = require("config.codecompanion.prompts.meetings").meeting_prep,
  ["Meeting Cleanup"] = require("config.codecompanion.prompts.meetings").meeting_cleanup,

  ["AI Rabbi"] = require("config.codecompanion.prompts.ai-rabbi"),

  -- Code Examples
  ["Code: Snippet"] = require("config.codecompanion.prompts.coding-examples").snippet,
  ["Code: Good vs Bad"] = require("config.codecompanion.prompts.coding-examples").good_bad_example,
}

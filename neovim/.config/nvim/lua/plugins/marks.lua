local k = require("helpers").k
local k_cmd = require("helpers").k_cmd
local bk = "<leader>bl"

return {
  {
    "chentoast/marks.nvim",
    event = "VeryLazy",
    opts = {
      force_write_shada = true,
      -- Bookmark as wrong
      bookmark_0 = {
        sign = "",
        annotate = true,
      },
      -- Bookmark as flagged/important
      bookmark_9 = {
        sign = "⚑",
        annotate = true,
      },
      -- Bookmark as confusing/with a question
      bookmark_8 = {
        sign = "",
        annotate = true,
      },
      -- Bookmark as info (useful but not wrong/good/home)
      bookmark_7 = {
        sign = "",
        annotate = true,
      },
      -- Bookmark as home (where I'm currently working)
      bookmark_6 = {
        sign = "",
        annotate = true,
      },
      -- Bookmark as known good
      bookmark_5 = {
        sign = "",
        annotate = true,
      },
      mappings = {
        next_bookmark0 = "]0",
        next_bookmark9 = "]9",
        next_bookmark8 = "]8",
        next_bookmark7 = "]7",
        next_bookmark6 = "]6",
        next_bookmark5 = "]5",
        prev_bookmark0 = "[0",
        prev_bookmark9 = "[9",
        prev_bookmark8 = "[8",
        prev_bookmark7 = "[7",
        prev_bookmark6 = "[6",
        prev_bookmark5 = "[5",
        delete_bookmark0 = "dm0",
        delete_bookmark9 = "dm9",
        delete_bookmark8 = "dm8",
        delete_bookmark7 = "dm7",
        delete_bookmark6 = "dm6",
        delete_bookmark5 = "dm5",
      },
    },
    keys = {
      k_cmd({
        key = bk .. "a",
        action = "MarksQFListAll",
        desc = "List all marks everywhere",
      }),
      k_cmd({
        key = bk .. "g",
        action = "MarksQFListGlobal",
        desc = "List all global marks",
      }),
      k_cmd({
        key = bk .. "l",
        action = "MarksQFListBuf",
        desc = "List all local marks in loclist",
      }),
      k({
        key = bk .. "G",
        action = ":BookmarksQFList ",
        desc = "List all bookmarks in group <x>",
      }),
      k_cmd({
        key = bk .. "A",
        action = "BookmarksQFListAll",
        desc = "List all bookmarks in all groups",
      }),
    },
  },
}

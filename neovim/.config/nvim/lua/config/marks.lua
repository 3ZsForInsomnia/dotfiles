local M = {}

function M.setup()
  require 'marks'.setup({
    -- whether to map keybinds or not. default true
    default_mappings = true,
    -- which builtin marks to show. default {}
    builtin_marks = { ".", "<", ">", "^" },
    -- whether movements cycle back to the beginning/end of buffer. default true
    cyclic = true,
    -- whether the shada file is updated after modifying uppercase marks. default false
    force_write_shada = true,
    -- how often (in ms) to redraw signs/recompute mark positions.
    -- higher values will have better performance but may cause visual lag,
    -- while lower values may cause performance penalties. default 150.
    refresh_interval = 250,
    -- sign priorities for each type of mark - builtin marks, uppercase marks, lowercase
    -- marks, and bookmarks.
    -- can be either a table with all/none of the keys, or a single number, in which case
    -- the priority applies to all marks.
    -- default 10.
    sign_priority = { lower = 10, upper = 15, builtin = 8, bookmark = 20 },
    -- disables mark tracking for specific filetypes. default {}
    excluded_filetypes = {},
    -- marks.nvim allows you to configure up to 10 bookmark groups, each with its own
    -- sign/virttext. Bookmarks can be used to group together positions and quickly move
    -- across multiple buffers. default sign is '!@#$%^&*()' (from 0 to 9), and
    -- default virt_text is "".
    -- Bookmark as good
    bookmark_0 = {
      sign = "",
      -- explicitly prompt for a virtual line annotation when setting a bookmark from this group.
      -- defaults to false.
      annotate = true,
    },
    -- Bookmark as flagged/normal path of investigation
    bookmark_9 = {
      sign = "⚑",
      -- explicitly prompt for a virtual line annotation when setting a bookmark from this group.
      -- defaults to false.
      annotate = true,
    },
    -- Bookmark as confusing/with a question
    bookmark_8 = {
      sign = "",
      -- explicitly prompt for a virtual line annotation when setting a bookmark from this group.
      -- defaults to false.
      annotate = true,
    },
    -- Bookmark as wrong
    bookmark_7 = {
      sign = "",
      -- explicitly prompt for a virtual line annotation when setting a bookmark from this group.
      -- defaults to false.
      annotate = true,
    },
    -- Bookmark as home (where I'm currently working)
    bookmark_6 = {
      sign = "ﳐ",
      -- explicitly prompt for a virtual line annotation when setting a bookmark from this group.
      -- defaults to false.
      annotate = true,
    },
    -- Bookmark as info (useful but not wrong/good/home)
    bookmark_5 = {
      sign = "",
      -- explicitly prompt for a virtual line annotation when setting a bookmark from this group.
      -- defaults to false.
      annotate = true,
    },
    mappings = {
      next_bookmark0 = "M0",
      next_bookmark9 = "M9",
      next_bookmark8 = "M8",
      next_bookmark7 = "M7",
      next_bookmark6 = "M6",
      next_bookmark5 = "M5",
    }
  })
end

return M

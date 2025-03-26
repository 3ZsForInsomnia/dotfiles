local keys = require("helpers")
local cmd = keys.k_cmd
local k = keys.k
local o = "<leader>n"
local c = vim.cmd

-- This is the full format for the title of a daily note
-- 9 - Resources/94 - Old activity notes/YYYY/YYYY-[Q]Q/YYYY-MMM/YYYY-[W]WW/YYYY-MMM-DD-dddd.md

local notesPath = vim.fn.expand("$HOME") .. "/Documents/sync"
local baseFolder = "9 - Resources/94 - Old activity notes"

local escapeSpaces = function(path)
  return path:gsub(" ", "\\ ")
end

local getNoteFunctions = {
  Daily = _G.getCurrentDayNote,
  Weekly = _G.getCurrentWeekNote,
  Monthly = _G.getCurrentMonthNote,
  Quarterly = _G.getCurrentQuarterNote,
  Yearly = _G.getCurrentYearNote,
}
_G.getCurrentForNoteType = function(noteType)
  return getNoteFunctions[noteType]()
end

local dateMap = {
  Day = function()
    return os.date("%A")
  end,
  Daily = function()
    return os.date("%d")
  end,
  Weekly = function()
    return os.date("%V")
  end,
  Monthly = function()
    return os.date("%m")
  end,
  Quarterly = function()
    return math.ceil(tonumber(os.date("%m")) / 3)
  end,
  Yearly = function()
    return os.date("%Y")
  end,
}
_G.datePiece = function(piece)
  return dateMap[piece]()
end

_G.openNote = function(noteType)
  local name = _G.getCurrentForNoteType(noteType)
  local notePath = notesPath .. "/" .. name
  local f = io.open(notePath, "r")

  if f then
    f:close()
    c("e " .. notePath)
    return
  end

  c("ObsidianNew " .. escapeSpaces(name))
  c("ObsidianTemplate " .. noteType .. "Note.md")
end

-- 9 - Resources/94 - Old activity notes/YYYY
local yearFolder = function()
  return baseFolder .. "/" .. _G.datePiece("Yearly")
end
_G.getCurrentYearNote = function()
  return yearFolder() .. "/" .. _G.datePiece("Yearly") .. ".md"
end

-- .../YYYY-[Q]Q
local quarterFile = function()
  return _G.datePiece("Yearly") .. "-Q" .. _G.datePiece("Quarterly")
end
local quarterFolder = function()
  return yearFolder() .. "/" .. quarterFile()
end
_G.getCurrentQuarterNote = function()
  return quarterFolder() .. "/" .. quarterFile() .. ".md"
end

-- .../YYYY-MMM
local monthFile = function()
  return _G.datePiece("Yearly") .. "-" .. _G.datePiece("Monthly")
end
local monthFolder = function()
  return quarterFolder() .. "/" .. monthFile()
end
_G.getCurrentMonthNote = function()
  return monthFolder() .. "/" .. monthFile() .. ".md"
end

-- .../YYYY-[W]WW
local weekFile = function()
  return _G.datePiece("Yearly") .. "-W" .. _G.datePiece("Weekly")
end
local weekFolder = function()
  return monthFolder() .. "/" .. weekFile()
end
_G.getCurrentWeekNote = function()
  return weekFolder() .. "/" .. weekFile() .. ".md"
end

-- .../YYYY-MMM-DD-dddd
local dailyFile = function()
  return _G.datePiece("Yearly")
    .. "-"
    .. _G.datePiece("Monthly")
    .. "-"
    .. _G.datePiece("Daily")
    .. "-"
    .. _G.datePiece("Day")
end
_G.getCurrentDayNote = function()
  return weekFolder() .. "/" .. dailyFile() .. ".md"
end

local openYearly = "lua openNote('Yearly')"
local openQuarterly = "lua openNote('Quarterly')"
local openMonthly = "lua openNote('Monthly')"
local openWeekly = "lua openNote('Weekly')"
local openDaily = "lua openNote('Daily')"

return {
  {
    "epwalsh/obsidian.nvim",
    event = "VeryLazy",
    config = function(_, opts)
      vim.keymap.set("n", "gf", function()
        if require("obsidian").util.cursor_on_markdown_link() then
          return "<cmd>ObsidianFollowLink<CR>"
        else
          return "gf"
        end
      end, { noremap = false, expr = true })

      require("obsidian").setup(opts)
    end,
    opts = {
      dir = "~/Documents/sync",
      workspaces = {
        {
          name = "notes",
          path = notesPath,
        },
      },
      open_notes_in = "current",
      finder = "telescope.nvim",
      -- completion = {
      --   nvim_cmp = true,
      -- },
      note_id_func = function(title)
        return title
      end,
      disable_frontmatter = false,
      templates = {
        subdir = "9 - Resources/90 - Templates",
        date_format = "%Y-%m-%d",
        time_format = "%H:%M",
      },
      attachments = {
        img_folder = "9 - Resources/98 - Attachments",
      },
      follow_url_func = function(url)
        -- vim.fn.jobstart({ "cmd.exe /C start", url }) -- Linux in WSL
        vim.fn.jobstart({ "open", url }) -- Mac OS
        -- vim.fn.jobstart({ "xdg-open", url }) -- linux
      end,
      open_app_foreground = true,
      wiki_link_func = function(opts)
        return require("obsidian.util").wiki_link_id_prefix(opts)
      end,
    },
    keys = {
      k({
        key = o .. "n",
        action = ":ObsidianNew ",
        desc = "Create a new note",
      }),
      cmd({
        key = o .. "q",
        action = "ObsidianQuickSwitch",
        desc = "Open quick switch",
      }),
      cmd({
        key = o .. "i",
        action = "ObsidianTemplate",
        desc = "Insert template",
      }),
      cmd({
        key = o .. "l",
        action = "ObsidianLink",
        desc = "Insert link",
      }),
      cmd({
        key = o .. "f",
        action = "ObsidianFollowLink",
        desc = "Follow link",
      }),
      cmd({
        key = o .. "o",
        action = "ObsidianOpen",
        desc = "Open note in buffer in Obsidian app",
      }),
      k({
        key = o .. "e",
        action = ":ObsidianExtractNote ",
        desc = "Extract visual selection to a new note",
      }),
      cmd({
        key = o .. "r",
        action = "ObsidianRename",
        desc = "Rename note",
      }),
      k({
        key = o .. "p",
        action = ":ObsidianPasteImg ",
        desc = "Paste image from clipboard with name",
      }),
      cmd({
        key = o .. "T",
        action = "ObsidianTOC",
        desc = "Navigate table of contents",
      }),
      cmd({
        key = o .. "t",
        action = openDaily,
        desc = "Open daily note",
      }),
      cmd({
        key = o .. "w",
        action = openWeekly,
        desc = "Open weekly note",
      }),
      cmd({
        key = o .. "d",
        action = openMonthly,
        desc = "Open monthly note",
      }),
      cmd({
        key = o .. "q",
        action = openQuarterly,
        desc = "Open quarterly note",
      }),
      cmd({
        key = o .. "y",
        action = openYearly,
        desc = "Open yearly note",
      }),
    },
  },
}

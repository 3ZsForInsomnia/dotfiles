local keys = require("helpers")
local cmd = keys.k_cmd
local k = keys.k
local o = "<leader>n"
local c = vim.cmd
local home = os.getenv("HOME")
local notesPath = home .. "/Documents/sync"
local baseFolder = function()
  return "9 - Resources/94 - Old activity notes/"
end

local catm = function(a, b)
  return a() .. b() .. ".md"
end
local catf = function(a, b)
  return a() .. b() .. "/"
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

-- This is the full format for the title of a daily note
-- 9 - Resources/94 - Old activity notes/YYYY/YYYY-[Q]Q/YYYY-MMM/YYYY-[W]WW/YYYY-MMM-DD-dddd.md

-- 9 - Resources/94 - Old activity notes/YYYY
local yearFolder = function()
  return catf(baseFolder, dateMap["Yearly"])
end
local getCurrentYearNote = function()
  return yearFolder .. dateMap["Yearly"]() .. ".md"
end

-- .../YYYY-[Q]Q
local quarterFile = function()
  return dateMap["Yearly"]() .. "-Q" .. dateMap["Quarterly"]()
end
local quarterFolder = function()
  return catf(yearFolder, quarterFile)
end
local getCurrentQuarterNote = function()
  return catm(quarterFolder, quarterFile)
end

-- .../YYYY-MMM
local monthFile = function()
  return dateMap["Yearly"]() .. "-" .. dateMap["Monthly"]()
end
local monthFolder = function()
  return catf(quarterFolder, monthFile)
end
local getCurrentMonthNote = function()
  return catm(monthFolder, monthFile)
end

-- .../YYYY-[W]WW
local weekFile = function()
  return dateMap["Yearly"]() .. "-W" .. dateMap["Weekly"]()
end
local weekFolder = function()
  return catf(monthFolder, weekFile)
end
local getCurrentWeekNote = function()
  return catm(weekFolder, weekFile)
end

-- .../YYYY-MMM-DD-dddd
local dailyFile = function()
  return dateMap["Yearly"]() .. "-" .. dateMap["Monthly"]() .. "-" .. dateMap["Daily"]() .. "-" .. dateMap["Day"]()
end
local getCurrentDayNote = function()
  return catm(weekFolder, dailyFile)
end

local getNoteFunctions = {
  Daily = getCurrentDayNote,
  Weekly = getCurrentWeekNote,
  Monthly = getCurrentMonthNote,
  Quarterly = getCurrentQuarterNote,
  Yearly = getCurrentYearNote,
}

_G.openNote = function(noteType)
  local name = getNoteFunctions[noteType]()
  local notePath = notesPath .. "/" .. name
  local f = io.open(notePath, "r")

  if f then
    f:close()
    c("e " .. notePath)
    return
  end

  c("ObsidianNew " .. name:gsub(" ", "\\ "))
  c("ObsidianTemplate " .. noteType .. "Note.md")
end

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
      dir = home .. "/Documents/sync",
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
        mode = "v",
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
        mode = "v",
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
        action = "lua openNote('Daily')",
        desc = "Open daily note",
      }),
      cmd({
        key = o .. "w",
        action = "lua openNote('Weekly')",
        desc = "Open weekly note",
      }),
      cmd({
        key = o .. "m",
        action = "lua openNote('Monthly')",
        desc = "Open monthly note",
      }),
      cmd({
        key = o .. "q",
        action = "lua openNote('Quarterly')",
        desc = "Open quarterly note",
      }),
      cmd({
        key = o .. "y",
        action = "lua openNote('Yearly')",
        desc = "Open yearly note",
      }),
    },
  },
}

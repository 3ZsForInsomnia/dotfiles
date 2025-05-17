local v = vim
local c = v.cmd

local keys = require("helpers")
local cmd = keys.k_cmd

local o = "<leader>n"
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
    "obsidian-nvim/obsidian.nvim",
    version = "*",
    lazy = true,
    ft = { "markdown" },
    -- event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function(_, opts)
      v.keymap.set("n", "gf", function()
        if require("obsidian").util.cursor_on_markdown_link() then
          return "<cmd>Obsidian follow_link hsplit<CR>"
        else
          return "gf"
        end
      end, { noremap = false, expr = true })

      require("obsidian").setup(opts)
    end,
    opts = {
      dir = notesPath,
      notes_subdir = "notes",
      workspaces = {
        {
          name = "notes",
          path = notesPath,
        },
      },

      open_notes_in = "current",
      disable_frontmatter = false,
      open_app_foreground = true,

      templates = {
        folder = "9 - Resources/90 - Templates",
        date_format = "%Y-%m-%d",
        time_format = "%H:%M",
      },

      attachments = {
        img_folder = "9 - Resources/98 - Attachments",
      },

      follow_url_func = function(url)
        v.ui.open(url)
      end,

      preferred_link_style = "wiki",
      wiki_link_func = function(opts)
        return require("obsidian.util").wiki_link_id_prefix(opts)
      end,

      note_id_func = function(title)
        return title
      end,

      completion = {
        nvim_cmp = false,
        blink = true,
        min_chars = 2,
      },

      picker = {
        name = "telescope.nvim",
        note_mappings = {
          -- Create a new note from your query.
          new = "<C-x>",
          -- Insert a link to the selected note.
          insert_link = "<C-l>",
        },
        tag_mappings = {
          -- Add tag(s) to current note.
          tag_note = "<C-x>",
          -- Insert a tag at the current location.
          insert_tag = "<C-l>",
        },
      },
      sort_by = "modified",
      sort_reversed = true,
    },
    keys = {
      cmd({
        key = o .. "n",
        action = "Obsidian new",
        desc = "Create a new note",
      }),
      cmd({
        key = o .. "Q",
        action = "Obsidian quick_switch",
        desc = "Open quick switch",
      }),
      cmd({
        key = o .. "i",
        action = "Obsidian template",
        desc = "Insert template",
      }),
      cmd({
        key = o .. "I",
        action = "Obsidian new_from_template",
        desc = "Create note with template",
      }),
      cmd({
        key = o .. "l",
        action = "Obsidian link",
        desc = "Insert link",
      }),
      cmd({
        key = o .. "l",
        action = "Obsidian link",
        desc = "Insert link",
        mode = "v",
      }),
      cmd({
        key = o .. "f",
        action = "Obsidian follow_link",
        desc = "Follow link",
      }),
      cmd({
        key = o .. "o",
        action = "Obsidian open",
        desc = "Open note in buffer in Obsidian app",
      }),
      cmd({
        key = o .. "s",
        action = "Obsidian search",
        desc = "Search notes",
      }),
      -- k({
      --   key = o .. "e",
      --   action = ":ObsidianExtractNote ",
      --   desc = "Extract visual selection to a new note",
      --   mode = "v",
      -- }),
      cmd({
        key = o .. "r",
        action = "Obsidian rename",
        desc = "Rename note",
      }),
      cmd({
        key = o .. "t",
        action = "Obsidian tags",
        desc = "Pick tags",
      }),
      cmd({
        key = o .. "p",
        action = "Obsidian paste_img",
        desc = "Paste image from clipboard with name",
      }),
      cmd({
        key = o .. "c",
        action = "Obsidian toc",
        desc = "Navigate table of contents",
      }),

      cmd({
        key = o .. "d",
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
  {
    "neo451/feed.nvim",
    cmd = "Feed",
    ---@module 'feed'
    ---@type feed.config
    opts = {},
    config = function()
      require("feed").setup({
        ui = {
          order = { "date", "feed", "tags", "title", "reading_time" },
          reading_time = {
            color = "Comment",
            format = function(id, db)
              local cpm = 1000
              local content = db:get(id):gsub("%s+", " ")
              local chars = v.fn.strchars(content)
              local time = math.ceil(chars / cpm)
              return string.format("(%s min)", time)
            end,
          },
          tags = {
            format = function(id, db)
              local icons = {
                nvimAndLua = "",
                angular = "",
                react = "",
                typescript = "",
                java = "",
                golang = "",
                python = "",
                finance = "💰",
                xkcd = "🧑‍💻",
                security = "🔒",
                programming = "💻",
              }

              local get_icon = function(name)
                if icons[name] then
                  return icons[name]
                end

                local has_mini, MiniIcons = pcall(require, "mini.icons")
                if has_mini then
                  local icon = MiniIcons.get("filetype", name)

                  if icon then
                    return icon .. " "
                  end
                end

                return name
              end

              local tags = vim.tbl_map(get_icon, db:get_tags(id))
              table.sort(tags)

              return "[" .. table.concat(tags, ", ") .. "]"
            end,
          },
        },
        feeds = {
          comics = {
            { "http://xkcd.com/rss.xml", name = "xkcd" },
          },
          music = {
            { "http://www.metalhammer.co.uk/rss" },
            { "http://loudwire.com/feed/" },
            { "http://www.blabbermouth.net/feed.rss" },
            { "http://www.angrymetalguy.com/feed/" },
            { "http://www.metalsucks.net/feed/rss/" },
            { "http://feeds2.feedburner.com/metalinjection" },
          },
          tech = {
            frontendFrameworks = {
              react = {
                { "https://overreacted.io/rss.xml" },
                { "http://facebook.github.io/react/feed.xml" },
              },
              angular = {
                { "https://blog.angular.io/feed" },
                { "https://medium.com/feed/@vsavkin" },
                { "https://netbasal.com/feed" },
                { "http://feeds.feedburner.com/juristrumpflohner" },
              },
            },
            frontendGeneral = {
              { "https://css-tricks.com/feed/" },
              { "http://feeds.feedburner.com/JohnPapa" },
              { "https://kentcdodds.com/blog/rss.xml" },
              { "https://blog.nrwl.io/feed" },
              { "http://feeds2.feedburner.com/leaverou" },
              { "http://www.chriskrycho.com/feed.xml" },
              { "https://coryrylan.com/feed.xml" },
              { "https://www.bennadel.com/rss tech webdev" },
              { "http://feeds.feedburner.com/Bludice tech webdev" },
            },
            design = {
              { "http://rss1.smashingmagazine.com/feed/ tech design" },
              { "http://feeds.feedburner.com/NirAndFar tech design" },
            },
            languages = {
              typescript = {
                { "https://devblogs.microsoft.com/typescript/feed/" },
                { "http://blogs.msdn.com/b/typescript/rss.aspx" },
                { "https://effectivetypescript.com/atom.xml" },
              },
              nodeAndJs = {
                { "https://cprss.s3.amazonaws.com/nodeweekly.com.xml" },
                { "https://nodejs.org/en/feed/blog.xml" },
                { "https://javascriptweekly.com/" },
                { "https://nodesource.com/blog/rss" },
              },
              python = {
                { "https://devblogs.microsoft.com/python/feed/" },
                { "https://realpython.com/atom.xml" },
                { "https://pbpython.com/feeds/all.atom.xml" },
              },
              golang = {
                { "https://go.dev/blog/feed.atom" },
                { "https://cprss.s3.amazonaws.com/golangweekly.com.xml" },
              },
              java = {
                { "https://feeds.feedblitz.com/baeldung" },
                { "https://devblogs.microsoft.com/java/feed/" },
              },
              nvimAndLua = {
                { "https://this-week-in-neovim.org/rss" },
                { "https://neovim.io/news.xml" },
                { "http://www.lua.org/news.rss" },
                { "https://medium.com/feed/@alpha2phi" },
                { "https://phaazon.net/blog/feed" },
              },
            },
            programming = {
              { "https://devblogs.microsoft.com/commandline/feed/" },
              { "https://itsfoss.com/rss/" },
              { "http://blog.cleancoder.com/atom.xml" },
              { "http://feeds.feedburner.com/mariusschulz" },
              { "http://thepracticaldev.com/feed" },
              { "http://martinfowler.com/bliki/bliki.atom" },
            },
            techBlogs = {
              { "http://artsy.github.io/feed" },
              { "https://engineering.atspotify.com/feed/" },
              { "https://www.etsy.com/codeascraft/rss" },
              { "https://medium.com/feed/airbnb-engineering" },
              { "https://netflixtechblog.com/feed" },
              { "https://engineering.fb.com/feed/" },
              { "https://github.blog/feed/" },
              { "https://github.blog/engineering.atom" },
              { "https://blog.developer.atlassian.com/feed/" },
              { "https://dropbox.tech/feed" },
            },
          },
          finance = {
            { "https://abnormalreturns.com/feed/" },
            { "https://alephblog.com/feed/" },
            { "https://ritholtz.com/feed/" },
            { "http://www.thereformedbroker.com/feed/" },
            { "http://awealthofcommonsense.com/feed/" },
          },
          productivity = {
            { "https://fortelabs.com/blog/blog/feed/" },
            { "https://jamesclear.com/feed" },
            { "https://calnewport.com/blog/feed/" },
            { "http://blog.trello.com/feed/" },
            { "https://timeular.com/feed/" },
            { "https://www.eleanorkonik.com/blog/rss/" },
            { "https://nesslabs.com/blog/feed" },
          },
          security = {
            { "http://www.schneier.com/blog/index.rdf" },
            { "http://krebsonsecurity.com/feed/" },
            { "http://feeds.feedburner.com/GoogleOnlineSecurityBlog" },
          },
        },
      })
    end,
  },
  {
    dir = "/Users/zacharylevinw/src/pacer.nvim/",
    cmd = { "PacerStart", "PacerPause", "PacerResume", "PacerResumeCursor" },
    config = function()
      require("pacer").setup({
        speed = 250,
        move_cursor = false,
        highlight = {
          bold = true,
        },
      })
    end,
  },
}

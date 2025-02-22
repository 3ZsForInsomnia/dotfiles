return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "moonfly",
      defaults = {
        autocmds = true,
        keymaps = true,
      },
      news = {
        lazyvim = true,
        neovim = true,
      },
      -- stylua: ignore
      icons = {
        ft = {
          octo = "",
        },
        dap = {
          Stopped             = { "󰁕 ", "DiagnosticWarn", "DapStoppedLine" },
          Breakpoint          = " ",
          BreakpointCondition = " ",
          BreakpointRejected  = { " ", "DiagnosticError" },
          LogPoint            = ".>",
        },
        diagnostics = {
          Error    = " ",
          Warn     = " ",
          Hint     = " ",
          Info     = " ",
          Question = " ",
        },
        git = {
          added    = " ",
          modified = " ",
          removed  = " ",
          Ignore   = " ",
          Rename   = " ",
          Diff     = " ",
          Repo     = " ",
        },
        kinds = {
          Array         = " ",
          Boolean       = "󰨙 ",
          Class         = " ",
          Codeium       = "󰘦 ",
          Color         = " ",
          Control       = " ",
          Collapsed     = " ",
          Constant      = "󰏿 ",
          Constructor   = " ",
          Copilot       = " ",
          Enum          = " ",
          EnumMember    = " ",
          Event         = " ",
          Field         = " ",
          File          = " ",
          Folder        = " ",
          Function      = "󰊕 ",
          Interface     = " ",
          Key           = " ",
          Keyword       = " ",
          Method        = "󰊕 ",
          Module        = " ",
          Namespace     = "󰦮 ",
          Null          = " ",
          Number        = "󰎠 ",
          Object        = " ",
          Operator      = " ",
          Package       = " ",
          Property      = " ",
          Reference     = " ",
          Snippet       = " ",
          String        = " ",
          Struct        = "󰆼 ",
          TabNine       = "󰏚 ",
          Text          = " ",
          TypeParameter = " ",
          Unit          = " ",
          Value         = " ",
          Variable      = "󰀫 ",
        },
        documents = {
          File = " ",
          Files = " ",
          Folder = " ",
          OpenFolder = " ",
        },
        text = {
          Text = "󰉿",
          Method = "󰆧",
          Function = "󰊕",
          Constructor = "",
          Field = "󰜢",
          Variable = "󰀫",
          Class = "󰠱",
          Interface = "",
          Module = "",
          Property = "󰜢",
          Unit = "󰑭",
          Value = "󰎠",
          Enum = "",
          Keyword = "󰌋",
          Snippet = "",
          Color = "󰏘",
          File = "󰈙",
          Reference = "󰈇",
          Folder = "󰉋",
          EnumMember = "",
          Constant = "󰏿",
          Struct = "󰙅",
          Event = "",
          Operator = "󰆕",
          TypeParameter = "",
        },
        common = {
          Arrow = " ",
          Lock = " ",
          Circle = " ",
          BigCircle = " ",
          BigUnfilledCircle = " ",
          Close = " ",
          NewFile = " ",
          Search = " ",
          Lightbulb = "󰌵 ",
          Project = " ",
          Dashboard = " ",
          History = " ",
          Comment = "󰅺 ",
          Bug = " ",
          Code = " ",
          Telescope = " ",
          Gear = " ",
          Package = " ",
          List = " ",
          SignIn = " ",
          Check = " ",
          Fire = " ",
          Note = " ",
          BookMark = " ",
          Pencil = "󰙏 ",
          ChevronRight = " ",
          Table = " ",
          Calendar = " ",
          SeparatorSquare = "█",
          SeparatorLStart = "",
          SeparatorLEndAngle = "",
          SeparatorLEnd = "",
          SeparatorRStartAngle = "",
          SeparatorRStart = "",
          SeparatorREnd = "",
        },
        misc = {
          dots = "󰇘",
          Robot = "ﮧ",
          Squirrel = "",
          Tag = "",
          Watch = "",
          Ghost1 = " ",
          Ghost2 = "󰊠",
          Carat = " ",
        }
      },
      ---@type table<string, string[]|boolean>?
      kind_filter = {
        default = {
          "Class",
          "Constructor",
          "Enum",
          "Field",
          "Function",
          "Interface",
          "Method",
          "Module",
          "Namespace",
          "Package",
          "Property",
          "Struct",
          "Trait",
        },
        markdown = false,
        help = false,
        -- you can specify a different filter for each filetype
        lua = {
          "Class",
          "Constructor",
          "Enum",
          "Field",
          "Function",
          "Interface",
          "Method",
          "Module",
          "Namespace",
          -- "Package", -- remove package since luals uses it for control flow structures
          "Property",
          "Struct",
          "Trait",
        },
      },
    },
  },
}

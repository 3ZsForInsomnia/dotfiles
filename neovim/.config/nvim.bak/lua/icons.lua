local M = {}

M.kind = {
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
}

M.type = {
  Array = "󰅨 ",
  Number = " ",
  String = "󰅳 ",
  Boolean = "󰾟 ",
  Object = "⦿ ",
}

M.documents = {
  File = " ",
  Files = " ",
  Folder = " ",
  OpenFolder = " ",
}

M.git = {
  Add = " ",
  Mod = " ",
  Remove = " ",
  Ignore = " ",
  Rename = " ",
  Diff = " ",
  Repo = " ",
}

M.common = {
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
  -- ChevronRight = "",
  ChevronRight = " ",
  Table = " ",
  Calendar = " ",
  SeparatorSquare = "█",
  SeparatorLStart = "█",
  -- SeparatorLStart = "",
  SeparatorLEndAngle = "",
  -- SeparatorLEnd = "",
  SeparatorRStartAngle = "",
  -- SeparatorRStart = "",
  SeparatorREnd = "█",
  -- SeparatorREnd = "",
}

M.diagnostics = {
  Error = " ",
  Warning = " ",
  Information = " ",
  Question = " ",
  Hint = " ",
}

M.misc = {
  Robot = "ﮧ",
  Squirrel = "",
  Tag = "",
  Watch = "",
  Ghost1 = " ",
  Ghost2 = "󰊠",
  Carat = " ",
}

M.border = {
  Single = {
    { "╭", "FloatBorder" },
    { "─", "FloatBorder" },
    { "╮", "FloatBorder" },
    { "│", "FloatBorder" },
    { "╯", "FloatBorder" },
    { "─", "FloatBorder" },
    { "╰", "FloatBorder" },
    { "│", "FloatBorder" },
  },
}

return M

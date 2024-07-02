local wk = require("which-key")

wk.register({
  m = {
    name = "Marks",
    ["0"] = "Investigating",
    ["9"] = "Flagged/important",
    ["8"] = "Bad",
    ["7"] = "Good",
    ["6"] = "Info",
    ["5"] = "Home",
  },
  ["["] = {
    name = "Previous Named Bookmark",
    ["0"] = "Investigating",
    ["9"] = "Flagged/important",
    ["8"] = "Bad",
    ["7"] = "Good",
    ["6"] = "Info",
    ["5"] = "Home",
  },
  ["]"] = {
    name = "Next Named Bookmark",
    ["0"] = "Investigating",
    ["9"] = "Flagged/important",
    ["8"] = "Bad",
    ["7"] = "Good",
    ["6"] = "Info",
    ["5"] = "Home",
  },
})

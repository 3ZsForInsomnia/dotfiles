local l = "<leader>s"
local k = require("helpers").k

local s = function(open, close)
  return "viw<esc>a" .. close .. "<esc>bi" .. open .. "<esc>lel"
end

-- Visual mode surround function
local sv = function(open, close)
  -- Use "c" to delete selection and enter insert mode
  -- Then insert opening chars + deleted text + closing chars
  return "c" .. open .. '<C-r>"' .. close .. "<esc>"
end

-- Normal mode mappings for surrounds
k({ key = l .. '"', action = s('"', '"'), desc = "Surround with double quotes" })
k({ key = l .. "'", action = s("'", "'"), desc = "Surround with single quotes" })
k({ key = l .. "`", action = s("`", "`"), desc = "Surround with backticks" })
k({ key = l .. "(", action = s("(", ")"), desc = "Surround with parentheses" })
k({ key = l .. "[", action = s("[", "]"), desc = "Surround with square brackets" })
k({ key = l .. "{", action = s("{", "}"), desc = "Surround with curly braces" })
k({ key = l .. "<", action = s("<", ">"), desc = "Surround with tags" })
k({ key = l .. "$", action = s("${", "}"), desc = "Surround with ${}" })
k({ key = l .. "~", action = s("~", "~"), desc = "Surround with ~" })

-- For doubled characters, call s directly with the right parameters
k({ key = l .. "t", action = s("~~", "~~"), desc = "Surround word with ~~" })
k({ key = l .. "e", action = s("==", "=="), desc = "Surround word with ==" })

-- Line surround function
local s3 = function(open, close)
  return "0i" .. open .. "<esc>$a" .. close .. "<esc>"
end

k({ key = l .. "lt", action = s3("~~", "~~"), desc = "Surround line with ~~" })
k({ key = l .. "le", action = s3("==", "=="), desc = "Surround line with ==" })
k({ key = l .. "ll", action = "0i - <esc>", desc = 'Prepend line with " - "' })

-- Visual mode mappings for surrounds
k({ mode = "v", key = l .. '"', action = sv('"', '"'), desc = "Surround selection with double quotes" })
k({ mode = "v", key = l .. "'", action = sv("'", "'"), desc = "Surround selection with single quotes" })
k({ mode = "v", key = l .. "`", action = sv("`", "`"), desc = "Surround selection with backticks" })
k({ mode = "v", key = l .. "(", action = sv("(", ")"), desc = "Surround selection with parentheses" })
k({ mode = "v", key = l .. "[", action = sv("[", "]"), desc = "Surround selection with square brackets" })
k({ mode = "v", key = l .. "{", action = sv("{", "}"), desc = "Surround selection with curly braces" })
k({ mode = "v", key = l .. "<", action = sv("<", ">"), desc = "Surround selection with tags" })
k({ mode = "v", key = l .. "$", action = sv("${", "}"), desc = "Surround selection with ${}" })
k({ mode = "v", key = l .. "~", action = sv("~", "~"), desc = "Surround selection with ~" })

-- Call sv directly with the doubled characters
k({ mode = "v", key = l .. "t", action = sv("~~", "~~"), desc = "Strikethrough selection" })
k({ mode = "v", key = l .. "e", action = sv("==", "=="), desc = "Highlight selection" })

-- Add additional highlighting mappings for Markdown/Obsidian
k({ mode = "v", key = l .. "b", action = sv("**", "**"), desc = "Bold selection" })
k({ mode = "v", key = l .. "i", action = sv("*", "*"), desc = "Italic selection" })
k({ mode = "v", key = l .. "h", action = sv("==", "=="), desc = "Highlight selection (alias)" })
k({ mode = "v", key = l .. "s", action = sv("~~", "~~"), desc = "Strikethrough selection (alias)" })
k({ mode = "v", key = l .. "c", action = sv("`", "`"), desc = "Code selection" })
k({ mode = "v", key = l .. "w", action = sv("[[", "]]"), desc = "Wiki link selection" })
k({ mode = "v", key = l .. "E", action = sv("![[", "]]"), desc = "Embed selection" })

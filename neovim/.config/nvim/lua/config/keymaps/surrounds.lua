local l = "<leader>s"
local k = require("helpers").k

local s = function(open, close)
  return "viw<esc>a" .. close .. "<esc>bi" .. open .. "<esc>lel"
end

k({ key = l .. '"', action = s('"', '"'), desc = "Surround with double quotes" })
k({ key = l .. "'", action = s("'", "'"), desc = "Surround with single quotes" })
k({ key = l .. "`", action = s("`", "`"), desc = "Surround with backticks" })
k({ key = l .. "(", action = s("(", ")"), desc = "Surround with parentheses" })
k({ key = l .. "[", action = s("[", "]"), desc = "Surround with square brackets" })
k({ key = l .. "{", action = s("{", "}"), desc = "Surround with curly braces" })
k({ key = l .. "<", action = s("<", ">"), desc = "Surround with tags" })
k({ key = l .. "$", action = s("${", "}"), desc = "Surround with ${}" })
k({ key = l .. "~", action = s("~", "~"), desc = "Surround with ~" })

local s2 = function(open)
  return s(open, open) .. "b" .. s(open, open)
end

k({ key = l .. "t", action = s2("~"), desc = "Surround word with ~~" })
k({ key = l .. "e", action = s2("="), desc = "Surround word with ==" })

local s3 = function(open)
  return "0i" .. open .. "<esc>$a" .. open .. "<esc>"
end

k({ key = l .. "lt", action = s3("~~"), desc = "Surround line with ~~" })
k({ key = l .. "le", action = s3("=="), desc = "Surround line with ==" })

k({ key = l .. "ll", action = "0i - <esc>", desc = 'Prepend line with " - "' })

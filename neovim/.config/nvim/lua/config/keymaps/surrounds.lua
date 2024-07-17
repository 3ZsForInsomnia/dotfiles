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

local wk = require("which-key")

local f = function(open, close)
  return "viw<esc>a" .. close .. "<esc>bi" .. open .. "<esc>lel"
end

wk.register({
  s = {
    name = "Surround (custom)",
    ['"'] = { f('"', '"'), "Surround with '\"'" },
    ["'"] = { f("'", "'"), "Surround with \'" },
    ['`'] = { f('`', '`'), "Surround with `" },
    ['('] = { f('(', ')'), "Surround with ()" },
    ['{'] = { f('{', '}'), "Surround with {}" },
    ['['] = { f('[', ']'), "Surround with []" },
    ['<'] = { f('<', '>'), "Surround with <>" },
    ['$'] = { f('${', '}'), "Surround with ${}" },
  },
}, { prefix = "<leader>" })

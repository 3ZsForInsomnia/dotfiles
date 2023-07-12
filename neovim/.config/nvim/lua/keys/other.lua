local wk = require("which-key")

local f = function(cmd)
  return "<cmd>Other " .. cmd .. "<cr>"
end

wk.register({
  a = {
    name = "Go to related files",
    [""] = { f(""), "Other" },
    s = { f("style"), "style (css, scss, theme)", },
    i = { f("types"), "types (interface, type, enum)", },
    t = { f("test"), "test (test, spec, mock)", },
    h = { f("template"), "html (html, any other template)", },
    a = {
      name = "Angular",
      [""] = { f("angular"), "Angular (service, routing, module, component, directive, pipe)" },
      r = { f("routing"), "routing", },
      m = { f("module"), "module", },
      c = { f("component"), "component", },
    },
    n = {
      name = "NgRx",
      [""] = { f("ngrx"), "NgRx (actions, reducer, effects, state/module, selectors)" },
      a = { f("actions"), "actions", },
      r = { f("reducer"), "reducer", },
      e = { f("effects"), "effects", },
      t = { f("state"), "state", },
      s = { f("selectors"), "selectors", },
    },
  },
}, { prefix = "<leader>f" })

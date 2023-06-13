local wk = require("which-key")

local f = function(cmd)
  return "<cmd>Other " .. cmd .. "<cr>"
end

wk.register({
  r = {
    name = "Go to related files",
    [""] = { f(""), "Other" },
    c = { f("style"), "style (css, scss, theme)", },
    i = { f("types"), "types (interface, type, enum)", },
    t = { f("test"), "test (test, spec, mock)", },
    h = { f("html"), "html (html, any other template)", },
    a = {
      name = "Angular",
      [""] = { f("angular"), "Angular (service, routing, module, component, directive, pipe)" },
      s = { f("service"), "service", },
      r = { f("routing"), "routing", },
      m = { f("module"), "module", },
      p = { f("pipe"), "pipe", },
      j = { f("component"), "component", },
      d = { f("directive"), "directive", },
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
}, { prefix = "<leader>" })

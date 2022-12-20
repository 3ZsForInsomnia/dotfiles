local wk = require("which-key")

local f = function(cmd)
  return "<cmd>Other" .. cmd .. "<cr>"
end

wk.register({
  o = {
    name = "Go to related",
    s = { f("css"), "css/scss file", },
    c = { f("controller"), "controller file", },
    m = { f("model"), "model file", },
    j = { f("component"), "component file", },
    e = { f("hbs"), "hbs file", },
    h = { f("html"), "html file", },
    a = {
      name = "Any matching",
      j = { f("anyjs"), "js file" },
      s = { f("anyjs"), "css/scss file" },
      h = { f("anyjs"), "html file" },
      e = { f("anyjs"), "hbs file" },
    },
  },
}, { prefix = "<leader>" })

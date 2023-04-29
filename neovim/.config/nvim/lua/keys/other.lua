local wk = require("which-key")

local f = function(cmd)
  return "<cmd>Other" .. cmd .. "<cr>"
end

wk.register({
  r = {
    name = "Go to related",
    s = { f("css"), "css/scss file", },
    c = { f("controller"), "controller file", },
    m = { f("model"), "model file", },
    j = { f("component"), "component file", },
    hb = { f("hbs"), "hbs file", },
    ht = { f("html"), "html file", },
    a = {
      name = "Any matching",
      j = { f("anyjs"), "js file" },
      s = { f("anycss"), "css/scss file" },
      h = { f("anyhtml"), "html file" },
      e = { f("anyhbs"), "hbs file" },
    },
  },
}, { prefix = "<leader>" })

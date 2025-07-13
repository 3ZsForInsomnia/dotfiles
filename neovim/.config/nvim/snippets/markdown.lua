local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node

return {
  s({
    trig = "url",
    name = "URL",
    desc = "Insert a URL",
  }, {
    t("["),
    i(1, "Text"),
    t("]("),
    i(2, "URL"),
    t(")"),
  }),
  s({
    trig = "ftnt",
    name = "Footnote",
    desc = "Insert a footnote",
  }, {
    t("[^"),
    i(1, "1"),
    t("]: "),
    i(2, "Footnote text"),
  }),
  s({
    trig = "callout",
    name = "Callout",
    desc = "Insert a callout",
  }, {
    t("> [!"),
    c(1, {
      t("info"),
      t("todo"),
      t("tip"),
      t("success"),
      t("question"),
      t("warning"),
      t("failure"),
      t("danger"),
      t("bug"),
      t("example"),
      t("quote"),
    }, {}),
    t("]"),
    t({ "", "> " }),
    i(2, "Text"),
  }),
}

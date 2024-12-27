local ls = require("luasnip")
-- some shorthands...
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local l = require("luasnip.extras").lambda
local rep = require("luasnip.extras").rep
local p = require("luasnip.extras").partial
local m = require("luasnip.extras").match
local n = require("luasnip.extras").nonempty
local dl = require("luasnip.extras").dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local types = require("luasnip.util.types")
local conds = require("luasnip.extras.conditions")
local conds_expand = require("luasnip.extras.conditions.expand")

return {
  s("de", { t("debugger;") }),
  s({ trig = "cl", name = "console.log", dscr = "Log a thing" }, { t('console.log("'), i(1), t('");') }),
  s(
    { trig = "clv", name = 'console.log("$1", $1);', dscr = "Log a thing" },
    { t('console.log("'), i(1), t('", '), rep(1), t(");") }
  ),
  s({
    trig = "clm",
    name = "map((a, i) => console.log(`a[${i}]:`, a);",
    dscr = "Log a thing in a pipe",
  }, { t('.map((a, i) => { console.log("a[i]: ", a); return a; })') }),
  s({ trig = "lp", name = "Let prop = this.prop;" }, { t("let "), i(1, "prop"), t(" = this."), rep(1), t(";") }),
}

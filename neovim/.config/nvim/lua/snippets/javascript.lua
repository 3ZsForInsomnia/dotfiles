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

local comments = require("snippets.utils.comments")

local getObservedProps = function(args)
  if #args == 0 or #args[1] == 0 then
    return
  end

  local observedProps = {}

  for j in ipairs(args[1]) do
    local doesHaveThis = string.match(args[1][j], "this.")
    if doesHaveThis ~= nil and doesHaveThis ~= "" then
      local assignedWithGet = string.match(args[1][j], "this.get%p%p%w")
      local assigned
      if assignedWithGet ~= nil and assignedWithGet ~= "" then
        assigned = assignedWithGet
        assigned = string.gsub(assigned, "this.get[();'\"]", "")
        assigned = string.gsub(assigned, "[);'\"]", "")
      else
        assigned = string.match(args[1][j], "this.%w+")
        assigned = string.gsub(assigned, "this.", "")
        assigned = string.gsub(assigned, ";", "")
      end
      -- assume never more than one per line - if 2+ happens, more complex than snippet should handle
      if assigned ~= nil and assigned ~= "" then
        table.insert(observedProps, assigned)
      end
    end
  end

  if #observedProps > 0 then
    local result = ""
    for _, v in ipairs(observedProps) do
      result = result .. '"' .. v .. '", '
    end
    return result
  else
    return ""
  end
end

return {
  s("de", { t("debugger;") }),
  s(
    { trig = "clv", name = 'console.log("$1", $1);', dscr = "Log a thing" },
    { t('console.log("'), i(1), t('", '), rep(1), t(");") }
  ),
  s({
    trig = "clm",
    name = 'map((a, i) => console.log(`a[${i}]:`, a);',
    dscr = "Log a thing in a pipe",
  }, { t('.map((a, i) => { console.log("a[i]: ", a); return a; })') }),
  s({
    trig = "efu",
    name = "Ember property function",
    dscr = "Ember property function with docstring",
  }, {
    t({ "/**", " * " }),
    i(3, "Summary"),
    t({ "", "" }),
    d(4, comments.docstringParams, { 2 }),
    t({ " **/", "" }),
    i(1, "name"),
    t("("),
    i(2, "params"),
    t({ ") {", "\t" }),
    i(0),
    t({ "", "}," }),
  }),
  s({ trig = "lp", name = "Let prop = this.prop;" }, { t("let "), i(1, "prop"), t(" = this."), rep(1), t(";") }),
  s({
    trig = "ecp",
    name = "Ember Computed Property",
    dscr = "Create an Ember computed property with automatic addition of Observed properties",
  }, {
    t({ "/**", " * " }),
    i(3, "Summary"),
    t({ "", " */", "" }),
    i(1, "propName"),
    t(": computed("),
    f(getObservedProps, 2),
    t({ "function() {", "\t" }),
    i(2, "body"),
    t({ "", "})," }),
  }),
  -- s({
  --   trig = 'etest',
  --   name = 'Ember Test',
  --   dsrc = 'Creates an Ember Test',
  --   -- can choose to have assert.expect(n), ticket (rt or adpr) or not
  -- }, {})
}

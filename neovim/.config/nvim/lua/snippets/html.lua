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

local tabs = function(count)
  return string.rep("\t", count)
end

local ul_helper
ul_helper = function(a1, b1, c1, count)
  return sn(nil, {
    c(1, {
      t({ "", "" }),
      sn(nil, {
        t(tabs(count) .. "<li>"),
        i(1, "list item"),
        t({ "</li>", "" }),
        d(2, ul_helper, {}, { user_args = { count } }),
      }),
      sn(nil, {
        t({ tabs(count) .. "<li>", tabs(count + 1) .. "<ul>", tabs(count + 2) .. "<li>" }),
        i(1, "list item"),
        t({ "</li>", "" }),
        d(2, ul_helper, {}, { user_args = { count + 2 } }),
        t({ tabs(count + 1) .. "</ul>", tabs(count) .. "</li>", "" }),
        -- This dynamicNode returns you to the previous nesting level
        d(3, ul_helper, {}, { user_args = { count } }),
      }),
    }),
  })
end

local getOlType = function(nestingLevel)
  local nestingIndex = nestingLevel % 3

  if nestingIndex == 1 then
    return 'type="1"'
  elseif nestingIndex == 2 then
    return 'type="a"'
  elseif nestingIndex == 0 then
    return 'type="i"'
  end
end

local ol_helper
ol_helper = function(a1, b1, c1, args)
  local indentationLevel = args.indentationLevel
  local nextNestingLevel = args.nextNestingLevel

  return sn(nil, {
    c(1, {
      t({ "", "" }),
      sn(nil, {
        t(tabs(indentationLevel) .. "<li>"),
        i(1, "list item"),
        t({ "</li>", "" }),
        d(2, ol_helper, {}, {
          user_args = {
            {
              indentationLevel = indentationLevel,
              nextNestingLevel = args.nextNestingLevel,
            },
          },
        }),
      }),
      sn(nil, {
        t({
          tabs(indentationLevel) .. "<li>",
          tabs(indentationLevel + 1) .. "<ol " .. getOlType(nextNestingLevel) .. ">",
          tabs(indentationLevel + 2) .. "<li>",
        }),
        i(1, "list item"),
        t({ "</li>", "" }),
        d(2, ol_helper, {}, {
          user_args = {
            {
              indentationLevel = indentationLevel + 2,
              nextNestingLevel = args.nextNestingLevel + 1,
            },
          },
        }),
        t({ tabs(indentationLevel + 1) .. "</ol>", tabs(indentationLevel) .. "</li>", "" }),
        -- This dynamicNode returns you to the previous nesting level
        d(3, ol_helper, {}, {
          user_args = {
            {
              indentationLevel = indentationLevel,
              nextNestingLevel = args.nextNestingLevel,
            },
          },
        }),
      }),
    }),
  })
end

return {
  s({
    trig = "ul",
    name = "Unordered List",
    dscr = "Unorderd list that autocreates new li tags with correct indentation and ordering levels",
    priority = 500,
  }, {
    t({ "<ul>", "\t<li>" }),
    i(1, "list item"),
    t({ "</li>", "" }),
    d(2, ul_helper, {}, { user_args = { 1 } }),
    t({ "</ul>", "" }),
    i(0),
  }),
  s({
    trig = "ol",
    name = "Ordered List",
    dscr = "Ordered list that autocreates new li tags with correct indentation and ordering levels",
    priority = 500,
  }, {
    t({ '<ol type="1">', "\t<li>" }),
    i(1, "list item"),
    t({ "</li>", "" }),
    d(2, ol_helper, {}, { user_args = { {
      indentationLevel = 1,
      nextNestingLevel = 2,
    } } }),
    t({ "</ol>", "" }),
    i(0),
  }),
  s({
    trig = "cn",
    name = "className",
    dscr = "className",
  }, {
    t({ 'className="' }),
    i(0, "classes"),
    t({ '"' }),
  }),
  s({
    trig = "ocl",
    name = "onClick",
    dscr = "onClick",
  }, {
    t({ "onClick={() => " }),
    i(0, "func"),
    t({ "}" }),
  }),
}

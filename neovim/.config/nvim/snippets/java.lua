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

local strings = require("neovim.config.nvim.lua.utils.strings")

return {
  s({
    trig = "@v",
    name = "@Valid",
  }, {
    t("@Valid"),
  }),
  s({
    trig = "@n",
    name = "@NotNull",
  }, {
    t("@NotNull"),
  }),
  s({
    trig = "@sm",
    name = "@Size(min/max = val)",
  }, {
    t("@Size("),
    c(1, { t("min"), t("max") }),
    t(" = "),
    i(2, "val"),
    t(")"),
  }),
  s({
    trig = "@s",
    name = "Property Serializer",
  }, {
    t("@JsonSerialize(using = "),
    c(1, {
      t("Serializer"),
      t("LowercaseStringEnumSerializer"),
      t("EnumSerializer"),
      t("ToStringSerializer"),
    }),
    t(".class)"),
  }),
  s({
    trig = "pgsw",
    name = "Getter/Setter/With",
    dsrc = "Create a prop with getter, setter and with functions for a param",
  }, {
    i(4, "Decorators?"),
    t({ "", "" }),
    t('@JsonProperty("'),
    f(function(args)
      return strings.camelToSnake(args[1][1])
    end, { 1 }),
    t({ '")', "" }),
    t("private "),
    i(2, "type"),
    t(" "),
    i(1, "propName"),
    t({ ";", "", "" }),
    d(3, function(args, snip)
      local propName = args[1][1]
      local type = args[2][1]

      local nodes = {}

      table.insert(nodes, t({ "public " .. type .. " get" .. strings.capitalizeFirstChar(propName) .. "() {", "" }))
      table.insert(nodes, t({ "\treturn " .. propName .. ";", "" }))
      table.insert(nodes, t({ "}", "", "" }))

      table.insert(
        nodes,
        t({
          "public void set" .. strings.capitalizeFirstChar(propName) .. "(" .. type .. " " .. propName .. ") {",
          "",
        })
      )
      table.insert(nodes, t({ "\tthis." .. propName .. " = " .. propName .. ";", "" }))
      table.insert(nodes, t({ "}", "", "" }))

      table.insert(
        nodes,
        t({
          "public "
            .. vim.split(snip.env.TM_FILENAME, ".", { plain = true })[1]
            .. " with"
            .. strings.capitalizeFirstChar(propName)
            .. "("
            .. type
            .. " "
            .. propName
            .. ") {",
          "",
        })
      )
      table.insert(nodes, t({ "\tthis." .. propName .. " = " .. propName .. ";", "" }))
      table.insert(nodes, t({ "\treturn this;", "" }))
      table.insert(nodes, t({ "}", "" }))

      return sn(nil, nodes)
    end, { 1, 2 }),
  }),
  s({
    trig = "tsh",
    name = "toString helper",
  }, {
    t({ "", '.add("' }),
    i(1, "propName"),
    t('", '),
    rep(1),
    t({ ")", "" }),
  }),
  s({
    trig = "obeq",
    name = "Object equality",
  }, {
    t("&& "),
    c(1, {
      sn(nil, { i(1, "prop"), t(" == that."), rep(1), t("") }),
      sn(nil, { t("Object.equals("), i(1, "prop"), t(", that."), rep(1), t(")") }),
    }),
    t({ "", "" }),
  }),
}

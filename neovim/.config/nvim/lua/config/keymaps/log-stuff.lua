local k = require("helpers").k

_G.logThis = function(str)
  local ft = vim.bo.filetype
  str = string.gsub(str, "%s+", "")

  if ft == "javascript" or ft == "typescript" or ft == "javascriptreact" or ft == "typescriptreact" then
    return 'console.log("' .. str .. '", ' .. str .. ");"
  elseif ft == "lua" then
    return 'print("' .. str .. '", vim.inspect(' .. str .. "))"
  elseif ft == "go" then
    return 'fmt.Println("' .. str .. '", ' .. str .. ")"
  end

  return "echo $" .. str
end

k({
  key = "<leader>" .. "zl",
  action = 'vaw"qyo<c-r>=luaeval(\'logThis(vim.fn.getreg("q"))\')<cr><esc><up>',
  desc = "Insta-log anything while in normal mode",
})

k({
  key = "<C-l>",
  action = '<esc>vaw"qyo<c-r>=luaeval(\'logThis(vim.fn.getreg("q"))\')<cr><up>',
  desc = "Insta-log anything while in insert mode",
  mode = "i",
})

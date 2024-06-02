local getInstalled = function()
  local servers = require('mason-lspconfig').get_installed_servers()
  local packages = require('mason-registry').get_installed_package_names()

  local handle = io.popen('~/mason.txt', 'w')
  for i=1,#servers do
    handle:write(servers[i])
  end

  for i=1,#packages do
    handle:write(packages[i])
  end
  handle:close()
end

local install = function()
  local servers = require('mason-lspconfig').get_installed_servers()
  local packages = require('mason-registry').get_installed_package_names()

  for i=1,#servers do
    vim.cmd "MasonInstall " .. servers[i]
  end

  for i=1,#packages do
    vim.cmd "MasonInstall " .. packages[i]
  end
end

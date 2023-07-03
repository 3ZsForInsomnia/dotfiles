local servers = require('mason-lspconfig').get_installed_servers()
for i=1,#servers do
  vim.cmd "MasonInstall " .. servers[i]
end

local packages = require('mason-registry').get_installed_package_names()
for i=1,#packages do
  vim.cmd "MasonInstall " .. packages[i]
end

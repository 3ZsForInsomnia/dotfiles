local angular = require("config.custom-other-mappings.angular")
local styles = require("config.custom-other-mappings.styles").styles

local M = {}

function M.setup()
  require("other-nvim").setup({
    mappings = {
      "angular",
      angular.angular,
      angular.component,
      angular.pipe,
      angular.module,
      angular.routing,
      angular.service,
      angular.directive,
      styles
    },
    transformers = {
      lowercase = function(inputString)
        return inputString:lower()
      end
    },
    style = {
      border = "solid",
      seperator = "|",
      width = 0.7,
      minHeight = 2
    },
  })
end

return M

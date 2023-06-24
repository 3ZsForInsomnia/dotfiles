local ng = require("config.custom-other-mappings.angular")
local ngrx = require("config.custom-other-mappings.ngrx")

local M = {}

function M.setup()
  require("other-nvim").setup({
    mappings = {
      unpack(ng.component),
      unpack(ng.style),
      unpack(ng.template),
      unpack(ng.test),
      unpack(ng.module),
      unpack(ng.routing),
      unpack(ng.other),

      unpack(ngrx.actions),
      unpack(ngrx.effects),
      unpack(ngrx.reducer),
      unpack(ngrx.state),
      unpack(ngrx.test),
      unpack(ngrx.selectors),

      -- unpack(ng.angular),
      -- unpack(ngrx.ngrx),
    },
    transformers = {
      lowercase = function(inputString)
        return inputString:lower()
      end
    },
    style = { border = "solid", seperator = "|", width = 0.9, minHeight = 2 }
  })
end

return M

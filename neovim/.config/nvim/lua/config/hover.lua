local M = {}

M.setup = function()
	local h = require("hover")

	local t = function()
		return true
	end
	local p = function(name, handler, enabled)
		h.register({
			name,
			enabled = enabled or t,
			execute = function(done)
				done({ lines = handler(), filetype = "markdown" })
			end,
		})
	end

	local clickupProvider = function()
    p("Clickup", function() return { "Test" } end)
	end
	local trelloProvider = function()
    p("Trello", function() return { "Test" } end)
  end

	h.setup({
		init = function()
			-- Builtin providers
			require("hover.providers.lsp")
			require("hover.providers.gh")
			-- require('hover.providers.gh_user')
			require("hover.providers.jira")
			-- require('hover.providers.man')
			require("hover.providers.dictionary")

			-- Custom providers
			clickupProvider()
      trelloProvider()
		end,
		preview_opts = {
			border = nil,
		},
		-- Whether the contents of a currently open hover window should be moved
		-- to a :h preview-window when pressing the hover keymap.
		preview_window = false,
		title = true,
	})
end

return M

local M = {}

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

M.clickupProvider = function()
	p("Clickup", function()
		return { "Test" }
	end)
end
M.trelloProvider = function()
	p("Trello", function()
		return { "Test" }
	end)
end

return M

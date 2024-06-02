local M = {}
-- Currently unused - <leader>le seems to do the same thing?

M.LSPWithDiagSource = {
	name = "LSPWithDiag",
	priority = 1000,
	enabled = function()
		return true
	end,
	execute = function(done)
		local util = require("vim.lsp.util")

		local params = util.make_position_params()
		---@type table<string>
		local lines = {}
		vim.lsp.buf_request_all(0, "textDocument/hover", params, function(responses)
			-- vim.notify("responses for hover request " .. vim.inspect(responses))
			local lang = "markdown"
			for _, response in pairs(responses) do
				if response.result and response.result.contents then
					lang = response.result.contents.language or "markdown"
					lines = util.convert_input_to_markdown_lines(
						response.result.contents or { kind = "markdown", value = "" }
					)
					lines = util.trim_empty_lines(lines or {})
				end
			end

			local unused
			local _, row = unpack(vim.fn.getpos("."))
			row = row - 1
			-- vim.notify("row " .. row)
			---@type Diagnostic[]
			local lineDiag = vim.diagnostic.get(0, { lnum = row })
			-- vim.notify("curently " .. #lineDiag .. " diagnostics")
			if #lineDiag > 0 then
				for _, d in pairs(lineDiag) do
					if d.message then
						lines = util.trim_empty_lines(util.convert_input_to_markdown_lines({
							language = lang,
							value = string.format(
								"[%s] - %s:%s",
								d.source,
								diagnostic_severities[d.severity],
								d.message
							),
						}, lines or {}))
					end
				end
			end
			for _, l in pairs(lines) do
				l = l:gsub("\r", "")
			end

			if not vim.tbl_isempty(lines) then
				done({ lines = lines, filetype = "markdown" })
				return
			end
			-- no results
			done()
		end)
	end,
}

return M

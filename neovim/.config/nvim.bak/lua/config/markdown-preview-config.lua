local M = {}

function M.setup()
	vim.g.mkdp_auto_close = 1
	vim.g.mkdp_refresh_slow = 1
	vim.g.gmkdp_refresh_slow = 1
	vim.g.mkdp_command_for_global = 1
	vim.g.mkdp_open_to_the_world = 0
	vim.g.mkdp_browser = "Google Chrome"
	vim.g.mkdp_echo_preview_url = 1
	vim.g.mkdp_preview_options = {
		mkit = {},
		katex = {},
		uml = {},
		maid = {},
		disable_sync_scroll = 0,
		sync_scroll_type = "middle",
		hide_yaml_meta = 1,
		sequence_diagrams = {},
		flowchart_diagrams = {},
	}
	vim.g.mkdp_port = "7777"
	vim.g.mkdp_page_title = "「${name}」"
end

return M

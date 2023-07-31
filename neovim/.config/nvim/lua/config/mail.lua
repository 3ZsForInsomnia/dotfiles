local M = {}

M.setup = function()
  local g = vim.g
	g.muttaliases_file = "~/.config/mutt/aliases"
  g.mailquery_folder = "~/.local/share/mail/comrade.topanga@gmail.com/INBOX/cur/"
  g.notmuch_filter = 1
  g.mailquery_filter = 1
end

return M

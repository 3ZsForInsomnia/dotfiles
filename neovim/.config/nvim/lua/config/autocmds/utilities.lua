-- Utility functions and helper autocmds
local v = vim
local a = v.api
local c = v.cmd
local au = a.nvim_create_autocmd

-- Quickfix item removal function
c([[
  function! RemoveQFItem()
    let curqfidx = line('.') - 1
    let qfall = getqflist()
    call remove(qfall, curqfidx)
    call setqflist(qfall, 'r')
    :copen
  endfunction
  :command! RemoveQFItem :call RemoveQFItem()
]])

-- Map dd to remove quickfix item
au("FileType", {
  pattern = "qf",
  command = "map <buffer> dd <cmd>RemoveQFItem<cr>",
})

-- Echo clearing timer function
c([[
  function! E()
    function! A(timer)
      echo ""
    endfunction
    call timer_start(15000, 'A')
  endfunction
  :command! E :call E()
]])

-- Clear echo on cursor hold
au("CursorHold", {
  pattern = "*",
  command = "call E()",
})

-- Emit CodeCompanion title to CodeCompanionHistory
au("User", {
  pattern = "CodeCompanionChatSubmitted",
  callback = function(ev)
    local ok, chat_mod = pcall(require, "codecompanion.interactions.chat")
    if not ok then
      return
    end

    local chat = chat_mod.buf_get_chat(ev.data.bufnr)
    if chat and chat.title and chat.title ~= "" then
      chat.opts.title = chat.title
    end
  end,
})

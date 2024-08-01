local M = {}

-- restore_buf_cursor jumps to the last visited file's position and open current fold.
M.restore_buffer_pos = function()
  if vim.fn.line([[`"]]) <= vim.fn.line([[$]]) then
    vim.cmd([[try | exec 'normal! g`"zzzO' | catch | endtry]])
  end
end

return M

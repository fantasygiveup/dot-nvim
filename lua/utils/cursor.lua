local M = {}

-- restore_buf_cursor jumps to the last visited file's position.
M.restore_buffer_pos = function()
  if vim.fn.line([[`"]]) <= vim.fn.line([[$]]) then
    vim.cmd([[try | exec 'normal! g`"zz' | catch | endtry]])
  end
end

M.toggle_fold_section = function()
  vim.cmd([[try | exec 'normal! zA' | catch | endtry]])
end

return M

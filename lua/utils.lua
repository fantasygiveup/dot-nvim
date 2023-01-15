local M = {}

-- restore_buf_cursor jumps to the last visited file's position.
M.restore_buf_cursor = function()
  if vim.fn.line([[`"]]) <= vim.fn.line([[$]]) then
    vim.cmd([[try | exec 'normal! g`"zz' | catch | endtry]])
  end
end

M.open_buffer_file = function(path)
  if vim.api.nvim_buf_get_name(0) == path then
    return
  end

  local ok, _ = pcall(vim.cmd, "e " .. path)
  if not ok then
    error("Could not open file: " .. path)
  end

  return ok
end

return M

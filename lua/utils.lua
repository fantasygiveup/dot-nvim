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

M.append_to_file = function(path, s)
  local fd = io.open(path, "r+")
  if not fd then
    error("Unable to open " .. path)
    return
  end

  -- Append a new line if it's not already appended.
  local maybe_eol = "\n"
  local eof = fd:seek("end")
  fd:seek("set", eof - 1)
  if fd:read(1) == maybe_eol then
    maybe_eol = ""
  end
  fd:seek("end")

  fd:write(string.format("%s%s", maybe_eol, s))
  fd:close()
  return 1
end

M.win_scroll_last_line = function(win, bufnr)
  local win = win or 0
  local bufnr = bufnr or 0
  local buf_lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, true)
  vim.api.nvim_win_set_cursor(win, { #buf_lines, 0 })
end

return M

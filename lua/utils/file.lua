local M = {}
local uv = vim.loop

M.file_exists = function(path)
  local stat = uv.fs_stat(path)
  return stat and stat.type == "file" or false
end

M.current_directory = function()
  local current_buffer = vim.api.nvim_buf_get_name(0)
  return vim.fn.fnamemodify(current_buffer, ":h")
end

return M

local M = {}
local uv = vim.loop

M.file_exists = function(path)
  local stat = uv.fs_stat(path)
  return stat and stat.type == "file" or false
end

return M

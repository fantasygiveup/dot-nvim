local M = {}

M.config = function()
  local ok, close_buffers = pcall(require, "close_buffers")
  if not ok then
    return
  end

  require("keymap").buffers(close_buffers)
end

return M

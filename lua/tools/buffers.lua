local M = {}

M.config = function()
  require("close_buffers").setup({})
  require("keymap").buffers()
end

return M

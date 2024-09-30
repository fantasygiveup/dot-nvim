local M = {}

M.config = function()
  require("hop").setup({})
  require("keymap").hop()
end

return M

local M = {}

M.config = function()
  local smart_split = require("smart-splits")

  smart_split.setup({})

  require("keymap").terminal_multiplexer()
end

return M

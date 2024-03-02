local M = {}

M.config = function()
  local ok, hop = pcall(require, "hop")
  if not ok then
    return
  end

  hop.setup({})

  require("keymap").hop()
end

return M

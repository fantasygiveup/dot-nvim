local M = {}

M.config = function()
  require("icon-picker").setup({})
  require("keymap").icon_picker()
end

return M

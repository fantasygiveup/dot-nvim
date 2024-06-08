local M = {}

M.config = function()
  local ok, icon_picker = pcall(require, "icon-picker")
  if not ok then
    return
  end

  icon_picker.setup({})

  require("keymap").icon_picker()
end

return M

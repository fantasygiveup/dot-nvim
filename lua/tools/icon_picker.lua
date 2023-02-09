local M = {}

M.setup = function(use)
  use({ "ziontee113/icon-picker.nvim", config = M.icon_picker_setup })
end

M.icon_picker_setup = function()
  local ok, icon_picker = pcall(require, "icon-picker")
  if not ok then
    return
  end

  icon_picker.setup({})

  vim.keymap.set("n", "<a-e>", "<cmd>IconPickerNormal<cr>")
  vim.keymap.set("i", "<a-e>", "<cmd>IconPickerInsert<cr>")
end

return M

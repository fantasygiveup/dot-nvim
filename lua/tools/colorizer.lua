local M = {}

M.config = function()
  local ok, colorizer = pcall(require, "colorizer")
  if not ok then
    return
  end

  colorizer.setup({
    DEFAULT_OPTIONS = { names = false },
  })

  vim.keymap.set("n", "<localleader>^", "<cmd>ColorizerToggle<cr>")
end

return M

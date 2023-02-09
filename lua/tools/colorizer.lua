local M = {}

M.setup = function(use)
  use({ "norcalli/nvim-colorizer.lua", config = M.colorizer_setup })
end

M.colorizer_setup = function()
  local ok, colorizer = pcall(require, "colorizer")
  if not ok then
    return
  end

  colorizer.setup({
      DEFAULT_OPTIONS = { names = false },
  })

  vim.keymap.set("n", "<localleader>tc", "<cmd>ColorizerToggle<cr>")
end

return M

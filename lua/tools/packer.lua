local M = {}

M.config = function(use)
  -- Add packer itself.
  use({ "wbthomason/packer.nvim", config = M.packer_setup })
end

M.packer_setup = function()
  vim.keymap.set("n", "<leader>pc", "<cmd>PackerCompile<cr>")
  vim.keymap.set("n", "<leader>ps", "<cmd>PackerSync<cr>")
end

return M

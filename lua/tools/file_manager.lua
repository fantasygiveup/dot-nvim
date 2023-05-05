local M = {}

M.config = function(use)
  use({
    "nvim-tree/nvim-tree.lua",
    config = M.file_manager_setup,
  })
end

M.file_manager_setup = function()
  local ok, nvim_tree = pcall(require, "nvim-tree")
  if not ok then
    return
  end

  nvim_tree.setup({
    sort_by = "case_sensitive",
    view = {
      width = 30,
    },
    renderer = {
      group_empty = true,
    },
    filters = {
      dotfiles = true,
    },
  })

  vim.keymap.set("n", "-", "<cmd>nohlsearch | NvimTreeFindFileToggle<cr>")
end

return M

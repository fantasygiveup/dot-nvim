local M = {}

M.setup = function(use)
  use({ "ziontee113/icon-picker.nvim", config = M.icon_picker })
  use({ "illia-danko/lf.vim", requires = { "rbgrouleff/bclose.vim" }, config = M.lf })
  use({ "norcalli/nvim-colorizer.lua", config = M.colorizer })
  use({ "kazhala/close-buffers.nvim", config = M.close_buffers })
end

M.icon_picker = function()
  local ok, icon_picker = pcall(require, "icon-picker")
  if not ok then
    return
  end

  icon_picker.setup({})

  vim.keymap.set("n", "<a-e>", "<cmd>IconPickerNormal<cr>")
  vim.keymap.set("i", "<a-e>", "<cmd>IconPickerInsert<cr>")
end

M.lf = function()
  vim.g.lf_replace_netrw = 1 -- use lf over netrw
  vim.g.lf_map_keys = 0

  vim.keymap.set("n", "-", "<cmd>nohlsearch | Lf<cr>")
end

M.colorizer = function()
  local ok, colorizer = pcall(require, "colorizer")
  if not ok then
    return
  end

  colorizer.setup({
    DEFAULT_OPTIONS = { names = false },
  })

  vim.keymap.set("n", "<localleader>tc", "<cmd>ColorizerToggle<cr>")
end

M.close_buffers = function()
  local ok, close_buffers = pcall(require, "close_buffers")
  if not ok then
    return
  end

  local ok, project = pcall(require, "project_nvim.project")
  if not ok then
    return
  end

  vim.keymap.set("n", "<localleader>do", function()
    close_buffers.wipe({ type = "other", force = true })
    print("Close other buffers")
  end, { desc = "close_other_buffers" })

  vim.keymap.set("n", "<localleader>d#", function()
    close_buffers.wipe({ type = "all", force = true })
    print("Close all buffers")
  end, { desc = "close_all_buffers" })

  vim.keymap.set("n", "<localleader>dp", function()
    local project_root = project.get_project_root()
    close_buffers.wipe({ regex = project_root, force = true })
    print(string.format("Close <%s> buffers", vim.fn.fnamemodify(project_root, ":t")))
  end, { desc = "close_project_buffers " })
end

return M

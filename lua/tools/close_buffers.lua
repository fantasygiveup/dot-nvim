local M = {}

M.setup = function(use)
  use({ "kazhala/close-buffers.nvim", config = M.close_buffers_setup })
end

M.close_buffers_setup = function()
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

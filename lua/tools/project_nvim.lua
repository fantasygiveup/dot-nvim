local M = {}

M.config = function(use)
  use({ "ahmedkhalf/project.nvim", config = M.project_nvim_setup })
end

M.project_nvim_setup = function()
  local ok, project_nvim = pcall(require, "project_nvim")
  if not ok then
    return
  end

  project_nvim.setup({
    patterns = { ".git", ".hg", ".bzr", ".svn" },
    detection_methods = { "pattern", "lsp" },
  })
end

return M

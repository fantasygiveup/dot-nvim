local M = {}

M.setup = function(use)
  use({ "ahmedkhalf/project.nvim", config = M.project_nvim_setup })
end

M.project_nvim_setup = function()
  local ok, project_nvim = pcall(require, "project_nvim")
  if not ok then
    return
  end

  project_nvim.setup({
    patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json", "go.mod" },
    detection_methods = { "pattern", "lsp" },
  })
end

return M

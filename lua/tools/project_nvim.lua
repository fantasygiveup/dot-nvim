local M = {}

M.config = function()
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

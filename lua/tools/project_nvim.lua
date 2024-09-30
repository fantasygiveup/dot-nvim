local M = {}

M.config = function()
  require("project_nvim").setup({
    patterns = { ".git", ".hg", ".bzr", ".svn", "go.mod", "Makefile" },
    detection_methods = { "pattern", "lsp" },
  })
end

return M

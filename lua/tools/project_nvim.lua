local M = {}

M.config = function()
  require("project_nvim").setup({
    patterns = { ".git", ".hg", ".bzr", ".svn", "go.mod", "Makefile", "mix.exs" },
    detection_methods = { "pattern", "lsp" },
  })
end

return M

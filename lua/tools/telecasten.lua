local M = {}

M.config = function()
  local ok, telekasten = pcall(require, "telekasten")
  if not ok then
    return
  end

  telekasten.setup({
    home = vim.fn.expand("~/zettelkasten"), -- Put the name of your notes directory here
  })
end

return M

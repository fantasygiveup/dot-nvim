local M = {}

M.config = function()
  local ok, devcontainer = pcall(require, "devcontainer")
  if not ok then
    return
  end

  devcontainer.setup({})
end

return M

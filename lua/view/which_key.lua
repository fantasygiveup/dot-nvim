local M = {}

M.config = function()
  local ok, which_key = pcall(require, "which-key")
  if not ok then
    return
  end

  which_key.setup({
    layout = { height = { min = 4, max = 15 } },
  })
end

return M

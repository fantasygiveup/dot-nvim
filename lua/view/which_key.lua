local M = {}

M.config = function()
  require("which-key").setup({
    layout = { height = { min = 4, max = 15 } },
  })
end

return M

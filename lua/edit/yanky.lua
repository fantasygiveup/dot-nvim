local M = {}

M.config = function()
  require("yanky").setup({
    highlight = { on_put = false, on_yank = false },
  })
  require("keymap").yanky()
end

return M
